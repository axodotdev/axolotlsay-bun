const { bin } = require("./package.json");
const execSync = require('child_process').execSync;

// Compute the target we're building for
const bunTargets = {
    "x86_64-pc-windows-msvc": "bun-windows-x64",
    "aarch64-apple-darwin": "bun-darwin-arm64",
    "x86_64-apple-darwin": "bun-darwin-x64",
    "aarch64-unknown-linux-gnu": "bun-linux-arm64",
    "x86_64-unknown-linux-gnu": "bun-linux-x64"
}
const distTarget = process.env.CARGO_DIST_TARGET || process.env.DIST_TARGET;
if (!distTarget) {
    throw "DIST_TARGET isn't set, so we don't know what platform to build!"
}
const bunTarget = bunTargets[distTarget];
if (!bunTarget) {
    throw `To the the best of our knowledge, bun does not support building for ${distTarget}`;
}
const binExt = distTarget.includes("windows") ? ".exe" : "";

// setup bun
execSync("bun install");

// for each binary, run bun
for (binName of Object.keys(bin)) {
    const binScript = bin[binName];
    const binPath = `${binName}${binExt}`;
    execSync(`bun build ${binScript} --compile --target ${bunTarget} --outfile ${binPath}`);
}
