#!/usr/bin/env bun

const yargs = require('yargs');
const { hideBin } = require('yargs/helpers');
const argv = yargs(hideBin(process.argv)).argv;

const msg = argv.msg;
console.log(msg);
