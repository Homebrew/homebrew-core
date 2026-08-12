class VitePlus < Formula
  desc "Unified toolchain and entry point for web development"
  homepage "https://viteplus.dev"
  url "https://github.com/voidzero-dev/vite-plus/archive/refs/tags/v0.2.9.tar.gz"
  sha256 "749f6bd91c31a0f1ddb5221c03058ea52a582becbf1d05aeb5a1cd3ad19b9559"
  license "MIT"
  head "https://github.com/voidzero-dev/vite-plus.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "99716ea8004a3354555d8229338bdf6e63bf716b7394aa1c3362fab38c387dbc"
    sha256 cellar: :any, arm64_sequoia: "b4bd3f5bd3860f5bf98c37b01d20c119d10675a661fcdd09b0f79388e07dbe61"
    sha256 cellar: :any, arm64_sonoma:  "f2f6cd7d12453a522af7656e549a82833853faead9496760bd2c84f84e025818"
    sha256 cellar: :any, sonoma:        "20c758acda38fd8aa79a91177449d38b0e25a6951ea89f9a4ac8fdcf994e6b3a"
    sha256               arm64_linux:   "471e07626a24417b3ee4c003e7e0e0a1008336882efb7fb8dcbfc0da8069cecb"
    sha256               x86_64_linux:  "ef78536f37dd64b97b879831c5023ea7507a4e944b453b37a924e9a31df6941e"
  end

  depends_on "cmake" => :build
  depends_on "just" => :build
  depends_on "rustup" => :build # TODO: try to restore stable rust: https://github.com/voidzero-dev/vite-task/commit/db99ba4d5d33323cc9e7b329f11bdea0610fbc7f
  depends_on "node"

  # Match the `packageManager`-pinned pnpm and vendor it so we can patch the
  # peer-resolution null-dereference that crashes `pnpm deploy --legacy` (see
  # `install`); Homebrew's own pnpm is read-only and hits the same bug.
  resource "pnpm" do
    url "https://registry.npmjs.org/pnpm/-/pnpm-11.20.0.tgz"
    sha256 "34e198cb1e43237517ecedfd31f9ae26a6c0a3e5366ce58a2d05f4b21fb5f19a"
  end

  resource "rolldown" do
    url "https://github.com/rolldown/rolldown.git",
        revision: "52dbd194ea6b6d4320706caa5f2db14b1034adaf"
    version "52dbd194ea6b6d4320706caa5f2db14b1034adaf"

    livecheck do
      url "https://raw.githubusercontent.com/voidzero-dev/vite-plus/refs/tags/v#{LATEST_VERSION}/packages/tools/.upstream-versions.json"
      strategy :json do |json|
        json.dig("rolldown", "hash")
      end
    end
  end

  resource "vite" do
    url "https://github.com/vitejs/vite.git",
        revision: "421615865dad3ed39137d17281814fc78a41246c"
    version "421615865dad3ed39137d17281814fc78a41246c"

    livecheck do
      url "https://raw.githubusercontent.com/voidzero-dev/vite-plus/refs/tags/v#{LATEST_VERSION}/packages/tools/.upstream-versions.json"
      strategy :json do |json|
        json.dig("vite", "hash")
      end
    end
  end

  def install
    resource("rolldown").stage buildpath/"rolldown"
    resource("vite").stage buildpath/"vite"

    # Run the pinned pnpm via a PATH shim so `just build`'s bare `pnpm` calls use
    # it too. Disable self-management: the pinned `@pnpm/exe.*` binary is absent
    # from the lockfiles, so a self-download cannot verify its identity.
    # TODO: check if you can remove ignore-unknown-native-binaries=true in a later version,
    # as this is needed to workaround an issue with @pnpm/exe.darwin-x64
    (buildpath/".npmrc").write "manage-package-manager-versions=false\nignore-unknown-native-binaries=true\n"
    resource("pnpm").stage buildpath/"pnpm-dist"
    pnpm_cjs = buildpath.glob("pnpm-dist/**/bin/pnpm.cjs").reject { |f| f.to_s.include?("/artifacts/") }.first

    # `pnpm deploy --legacy` re-resolves peers on the shared workspace lockfile
    # and crashes: `inheritedParentPkgBreaksPeerDiamond` calls `Object.keys` on a
    # resolved package whose `peerDependencies` is undefined. Guard the access.
    inreplace buildpath.glob("pnpm-dist/**/dist/pnpm.mjs"),
              "Object.keys(parentPkg.peerDependencies)",
              "Object.keys(parentPkg.peerDependencies ?? {})"

    (buildpath/"pnpm-shim").mkpath
    (buildpath/"pnpm-shim/pnpm").write <<~SH
      #!/bin/sh
      exec "#{formula_opt_bin("node")}/node" "#{pnpm_cjs}" "$@"
    SH
    chmod "+x", buildpath/"pnpm-shim/pnpm"
    ENV.prepend_path "PATH", buildpath/"pnpm-shim"

    system "just", "build"
    system "cargo", "install", *std_cargo_args(path: "crates/vp_global_cli")

    system "pnpm", "--filter=vite-plus", "deploy", "--prod", "--legacy", "--no-optional",
           prefix/"node_modules/vite-plus"
    node_modules = prefix/"node_modules/vite-plus/node_modules"
    rm_r node_modules.glob(".pnpm/*/node_modules/*/prebuilds/{darwin,ios}-x64*")
    rm_r node_modules.glob(".pnpm/fsevents@*/node_modules/fsevents")

    # Symlink vp to vpr and vpx. These are detected at runtime by argv[0]
    bin.install_symlink bin/"vp" => "vpr"
    bin.install_symlink bin/"vp" => "vpx"

    # Generate shell completions, vp uses clap but with a custom env var so we can't use our helper
    (bash_completion/"vp").write Utils.safe_popen_read({ "VP_COMPLETE" => "bash" }, bin/"vp")
    (fish_completion/"vp.fish").write Utils.safe_popen_read({ "VP_COMPLETE" => "fish" }, bin/"vp")
    (zsh_completion/"_vp").write Utils.safe_popen_read({ "VP_COMPLETE" => "zsh" }, bin/"vp")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/vp --version")

    system bin/"vp", "create", "vite:application", "--no-interactive", "--directory", "test-app"
    assert_path_exists testpath/"test-app/package.json"

    cd testpath/"test-app" do
      output = shell_output("#{bin}/vp fmt")
      assert_match "Finished", output
    end
  end
end
