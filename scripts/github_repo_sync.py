#!/usr/bin/env python3
import json
import sys
import urllib.error
import urllib.parse
import urllib.request
from dataclasses import dataclass
from typing import Optional

GITHUB_API = 'https://api.github.com'

@dataclass
class RepoRef:
    owner: str
    repo: str
    path: Optional[str] = None


def parse_repo_ref(url: str) -> Optional[RepoRef]:
    parsed = urllib.parse.urlsplit(url)
    host = (parsed.hostname or '').lower()
    if host not in {'github.com', 'www.github.com'}:
        return None

    parts = [part for part in parsed.path.split('/') if part]
    if len(parts) < 2:
        return None

    owner, repo = parts[0], parts[1].removesuffix('.git')
    if not owner or not repo:
        return None

    path = None
    if len(parts) >= 5 and parts[2] == 'tree':
        path = '/'.join(parts[4:]) or None
    return RepoRef(owner=owner, repo=repo, path=path)


def github_get(path: str):
    req = urllib.request.Request(f'{GITHUB_API}{path}', headers={
        'Accept': 'application/vnd.github+json',
        'User-Agent': 'stigenai-mcp-sync/1.0',
    })
    token = None
    import os
    token = os.getenv('GITHUB_TOKEN') or os.getenv('GH_TOKEN')
    if token:
        req.add_header('Authorization', f'Bearer {token}')
    with urllib.request.urlopen(req, timeout=20) as resp:
        return json.load(resp)


def get_repo_metadata(ref: RepoRef):
    return github_get(f'/repos/{ref.owner}/{ref.repo}')


def get_latest_commit(ref: RepoRef) -> Optional[str]:
    q = {'per_page': '1'}
    if ref.path:
        q['path'] = ref.path
    data = github_get(f'/repos/{ref.owner}/{ref.repo}/commits?{urllib.parse.urlencode(q)}')
    if isinstance(data, list) and data:
        return data[0].get('sha')
    return None


def get_latest_release(ref: RepoRef) -> Optional[str]:
    try:
        data = github_get(f'/repos/{ref.owner}/{ref.repo}/releases/latest')
    except urllib.error.HTTPError as e:
        if e.code == 404:
            return None
        raise
    return data.get('tag_name')


def collect(url: str):
    ref = parse_repo_ref(url)
    if not ref:
        return {'skip': True, 'reason': 'non-github', 'gitCommit': None, 'releaseVersion': None}

    metadata = get_repo_metadata(ref)
    archived = bool(metadata.get('archived'))
    disabled = bool(metadata.get('disabled'))
    if archived or disabled:
        reasons = []
        if archived:
            reasons.append('archived')
        if disabled:
            reasons.append('disabled')
        return {
            'skip': True,
            'reason': '+'.join(reasons),
            'gitCommit': None,
            'releaseVersion': None,
            'archived': archived,
            'disabled': disabled,
        }

    return {
        'skip': False,
        'reason': None,
        'gitCommit': get_latest_commit(ref),
        'releaseVersion': get_latest_release(ref),
        'archived': archived,
        'disabled': disabled,
    }


if __name__ == '__main__':
    if len(sys.argv) != 2:
        print('usage: github_repo_sync.py <repo-url>', file=sys.stderr)
        sys.exit(2)
    print(json.dumps(collect(sys.argv[1])))
