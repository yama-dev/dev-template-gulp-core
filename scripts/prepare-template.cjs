const fs = require('node:fs');
const path = require('node:path');

const root = path.resolve(__dirname, '..');
const version = process.argv[2];
if (!/^\d+\.\d+\.\d+$/.test(version || '')) {
  throw new Error('VERSION must be a release version (e.g. 1.16.0).');
}

const read = (file) => JSON.parse(fs.readFileSync(path.join(root, file), 'utf8'));
const write = (file, value) => fs.writeFileSync(path.join(root, file), JSON.stringify(value, null, 2) + '\n');
const pkg = read('package.json');
const template = read('template/package.json');
const lock = read('template/package-lock.json');
const coreName = '@yama-dev/dev-template-gulp-core';
const coreSource = `yama-dev/dev-template-gulp-core.git#v${version}`;
const gulpOptions = ` --gulpfile node_modules/${coreName}/gulpfile.mjs --cwd ./`;

pkg.version = version;
pkg.main = 'gulpfile.mjs';
template.version = version;
template.main = 'gulpfile.mjs';
template.devDependencies[coreName] = coreSource;
for (const name of ['develop', 'develop:php', 'develop:twig', 'production', 'preview', 'build', 'deploy']) {
  template.scripts[name] = template.scripts[name].replace(/ --gulpfile \S+ --cwd \S+/, '') + gulpOptions;
}
lock.version = version;
lock.packages[''].version = version;
lock.packages[''].devDependencies = { ...template.devDependencies };
lock.packages[''].engines = { ...template.engines };
lock.packages[`node_modules/${coreName}`] = {
  version,
  resolved: `git+ssh://git@github.com/${coreSource}`,
  dev: true,
  license: pkg.license,
  engines: { ...pkg.engines },
};
write('package.json', pkg);
write('template/package.json', template);
write('template/package-lock.json', lock);
