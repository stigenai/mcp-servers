# Security Policy

## Supported Versions

We release patches for security vulnerabilities in the following versions:

| Version | Supported          |
| ------- | ------------------ |
| latest  | :white_check_mark: |
| < 1.0   | :x:                |

## Reporting a Vulnerability

We take the security of our MCP server images seriously. If you believe you have found a security vulnerability in any of our Docker images or configurations, please report it to us as described below.

### How to Report

**Please do not report security vulnerabilities through public GitHub issues.**

Instead, please report them via one of the following methods:

1. **Email**: Send details to security@stigen.ai
2. **GitHub Security Advisories**: Create a private security advisory in this repository

### What to Include

Please include the following information to help us triage your report quickly:

- Type of issue (e.g., buffer overflow, SQL injection, cross-site scripting, etc.)
- Full paths of source file(s) related to the manifestation of the issue
- The location of the affected source code (tag/branch/commit or direct URL)
- Any special configuration required to reproduce the issue
- Step-by-step instructions to reproduce the issue
- Proof-of-concept or exploit code (if possible)
- Impact of the issue, including how an attacker might exploit it

### Response Timeline

- **Initial Response**: We will acknowledge receipt of your vulnerability report within 48 hours
- **Status Updates**: We will keep you informed about the progress of fixing the vulnerability
- **Fix Timeline**: We aim to release patches for critical vulnerabilities within 7 days
- **Disclosure**: We will coordinate with you on the disclosure timeline

## Security Best Practices

When using our MCP server images:

1. **Keep Images Updated**: Regularly pull the latest versions of our images
2. **Scan Images**: Use tools like Trivy to scan images before deployment
3. **Run as Non-Root**: All our images are configured to run as non-root users
4. **Network Security**: Implement proper network policies to restrict access
5. **Environment Variables**: Never expose sensitive data through environment variables

## Security Features

Our images include the following security features:

- **Non-root execution**: All containers run as non-privileged users
- **Minimal base images**: Using Alpine and slim variants to reduce attack surface
- **Regular updates**: Automated dependency updates via Dependabot
- **Vulnerability scanning**: Automated Trivy scans on all builds
- **Health checks**: Built-in health check endpoints for monitoring

## Known Security Considerations

- **Port 3000**: All MCP servers expose port 3000. Ensure proper network policies are in place
- **Browser automation**: Playwright server has access to Chromium for web automation
- **Package managers**: Images include package managers (pip, npm) that could be used to install additional packages

## Contact

For any security-related questions, please contact:
- Security Team: security@stigen.ai
- General Support: support@stigen.ai