import path from 'path';
import * as esbuild from 'esbuild'

const cssEntrypoints = [
  'assets/stylesheets/ui/entries/home/index.css',
  'assets/stylesheets/ui/entries/swallow/index.css',
    'assets/stylesheets/ui/entries/lizard/index.css',
]
const cssOutbase = 'assets/stylesheets'

const jsEntrypoints = [
  'javascript/ui/entries/home/index.js',
  'javascript/ui/entries/swallow/index.js',
    'javascript/ui/entries/lizard/index.js',
]
const jsOutbase = 'javascript'

const opt = {
  bundle: true,
  sourcemap: true,
  outdir: 'assets/builds',
  logLevel: 'info',
  absWorkingDir: path.join(process.cwd(), 'app'),
  loader: {
    '.css': 'css',
    '.js': 'js',
  },
}

let cssOpt = {
  ...opt,
  entryPoints: cssEntrypoints,
  outbase: 'assets/stylesheets',
}
let jsOpt = {
  ...opt,
  entryPoints: jsEntrypoints,
  outbase: 'javascript',
}
if (process.argv.includes('--watch')) {
  esbuild.context(cssOpt)
    .then(ctx => {
      ctx.watch().then(() => console.log('watching css...'))
    })
    .catch(() => process.exit(1));
  
  esbuild.context(jsOpt)
    .then(ctx => {
      ctx.watch().then(() => console.log('watching js...'))
    })
    .catch(() => process.exit(1));
} else {
  esbuild.build(cssOpt).catch(() => process.exit(1));
  esbuild.build(jsOpt).catch(() => process.exit(1));
}
