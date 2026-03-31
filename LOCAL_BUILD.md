# Local legacy Hexo build

This project builds reliably with a project-local **Node 18.20.8** and **Yarn 1.22.22**.
The system-global Node 22 environment is left untouched.

## Expected local runtime

The local Node binary should exist at:

```bash
.local/node-v18.20.8-linux-x64/bin/node
```

## Common commands

```bash
npm run use-local-node
npm run clean:local
npm run build:local
npm run server:local
npm run deploy:local
```

These commands use `scripts/use-local-node.sh` to prepend the local Node binary to `PATH`.
