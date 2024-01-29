/**
 * IMPORT MODULES
 */
import path from 'path';
import CONFIG from '../config/index.js';
import {
  src,
  dest,
} from 'gulp';
import ignore from 'gulp-ignore';
import changed from 'gulp-changed';

/**
 * Copy Task
 */
let taskCopy = ()=>{
  let _target = CONFIG.copyDirectory.slice();

  if(CONFIG.env.source !== CONFIG.env.sourceBuild){
    _target.push(`!${CONFIG.watchDirectory.jspre}`);
  }

  if(CONFIG.env.webpack){
    let _configfile_webpack = CONFIG.env.webpackConfig ? path.join(process.cwd(),CONFIG.env.webpackConfig) : path.join(process.cwd(),'webpack.config.js');
    let _webpackConfig = require(_configfile_webpack);
    for (const key in _webpackConfig.entry) {
      if (Object.hasOwnProperty.call(_webpackConfig.entry, key)) {
        _target.push(`!${CONFIG.env.source}**/*${path.basename(_webpackConfig.entry[key])}`);
      }
    }
  }

  return src(_target)
    .pipe(changed(CONFIG.outputDirectory.dev))
    .pipe(ignore.include({isFile: true}))
    .pipe(dest(CONFIG.outputDirectory.dev));
};

export default taskCopy;
