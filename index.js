#!/usr/bin/env node

// We do this because `require` gets rewritten to handle
// bundling properly, while the filesystem stuff that
// yargs does by default doesn't.
// If we don't do this, the default --version will be
// unable to report its own version when run outside
// the source directory.
const { version } = require("./package.json");

const yargs = require("yargs");
const { hideBin } = require("yargs/helpers");
const argv = yargs(hideBin(process.argv)).version(
  "--version",
  "Show version number",
  version,
).argv;

const msg = argv._[0];
console.log(`>o_o< ${msg}`);
