import pathlib
import sys
import unittest
from unittest import mock

sys.path.insert(0, str(pathlib.Path(__file__).resolve().parents[1] / 'scripts'))
import github_repo_sync as mod


class ParseRepoRefTests(unittest.TestCase):
    def test_parse_plain_repo_url(self):
        ref = mod.parse_repo_ref('https://github.com/stigenai/qdrant-mcp')
        self.assertEqual(ref.owner, 'stigenai')
        self.assertEqual(ref.repo, 'qdrant-mcp')
        self.assertIsNone(ref.path)

    def test_parse_tree_url(self):
        ref = mod.parse_repo_ref('https://github.com/modelcontextprotocol/servers/tree/main/src/time')
        self.assertEqual(ref.owner, 'modelcontextprotocol')
        self.assertEqual(ref.repo, 'servers')
        self.assertEqual(ref.path, 'src/time')


class CollectTests(unittest.TestCase):
    @mock.patch.object(mod, 'get_latest_release', return_value='v1.2.3')
    @mock.patch.object(mod, 'get_latest_commit', return_value='abc123')
    @mock.patch.object(mod, 'get_repo_metadata', return_value={'archived': False, 'disabled': False})
    def test_collect_active_repo(self, *_):
        result = mod.collect('https://github.com/stigenai/mcp-servers')
        self.assertFalse(result['skip'])
        self.assertEqual(result['gitCommit'], 'abc123')
        self.assertEqual(result['releaseVersion'], 'v1.2.3')

    @mock.patch.object(mod, 'get_repo_metadata', return_value={'archived': True, 'disabled': False})
    def test_collect_archived_repo(self, *_):
        result = mod.collect('https://github.com/stigenai/qdrant-mcp')
        self.assertTrue(result['skip'])
        self.assertEqual(result['reason'], 'archived')
        self.assertIsNone(result['gitCommit'])
        self.assertIsNone(result['releaseVersion'])

    @mock.patch.object(mod, 'get_repo_metadata', return_value={'archived': False, 'disabled': True})
    def test_collect_disabled_repo(self, *_):
        result = mod.collect('https://github.com/stigenai/disabled-repo')
        self.assertTrue(result['skip'])
        self.assertEqual(result['reason'], 'disabled')


if __name__ == '__main__':
    unittest.main()
