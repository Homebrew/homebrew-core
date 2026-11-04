class VitePlus < Formula
  desc "Unified toolchain and entry point for web development"
  homepage "https://viteplus.dev"
  url "https://github.com/voidzero-dev/vite-plus/archive/refs/tags/v1.5.0.tar.gz"
  sha256 "1b0de3dc75ceecd073591b65f90479d18372aa8151089868a07baedc2d9c7ca7"
  license "MIT"
  head "https://github.com/voidzero-dev/vite-plus.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "461edea9e67350d06870e347e923c44ccefaf75a5f1c35486a7a939d384a4a6b"
    sha256 cellar: :any, arm64_tahoe:       "9fbf3fd6ae3981b779ee486e06124eaa17aa7f36842cef9517e3dd52a4f70a3a"
    sha256 cellar: :any, arm64_sequoia:     "7aecbb69c0e2aa0b06a7675b5760d67fa340d3096f36248b57fc9a5d7ba61405"
    sha256               arm64_linux:       "cf45083e25c8c5712a727fdf0f1bb8b490c22876a679ae72fc89c914de25c343"
    sha256               x86_64_linux:      "07a3cd269d27bd949e7617fadb2cd64c1b8da42de5d358821d1086701988c50f"
  end

  depends_on "cmake" => :build
  depends_on "just" => :build
  depends_on "pkgconf" => :build
  depends_on "pnpm" => :build
  depends_on "rust" => :build
  depends_on "node"
  depends_on "sqlite"

  resource "rolldown" do
    url "https://github.com/rolldown/rolldown.git",
        revision: "de6facf2228279718e042b801dd6b60dd6503918"
    version "de6facf2228279718e042b801dd6b60dd6503918"

    livecheck do
      url "https://raw.githubusercontent.com/voidzero-dev/vite-plus/refs/tags/v#{LATEST_VERSION}/packages/tools/.upstream-versions.json"
      strategy :json do |json|
        json.dig("rolldown", "hash")
      end
    end
  end

  resource "vite" do
    url "https://github.com/vitejs/vite.git",
        revision: "981f07fa4580fb88b333c4450431e4715d2a0b82"
    version "981f07fa4580fb88b333c4450431e4715d2a0b82"

    livecheck do
      url "https://raw.githubusercontent.com/voidzero-dev/vite-plus/refs/tags/v#{LATEST_VERSION}/packages/tools/.upstream-versions.json"
      strategy :json do |json|
        json.dig("vite", "hash")
      end
    end
  end

  resource "oxc-node" do
    url "https://github.com/oxc-project/oxc-node.git",
        revision: "7ff14c3b1d15e2ef12310ee209d0b72b58fa880e"
    version "7ff14c3b1d15e2ef12310ee209d0b72b58fa880e"

    livecheck do
      url "https://raw.githubusercontent.com/voidzero-dev/vite-plus/refs/tags/v#{LATEST_VERSION}/packages/tools/.upstream-versions.json"
      strategy :json do |json|
        json.dig("oxc-node", "hash")
      end
    end
  end

  def install
    resource("rolldown").stage buildpath/"rolldown"
    resource("vite").stage buildpath/"vite"
    resource("oxc-node").stage buildpath/"oxc-node"

    # Apply Vite+'s branding and config patches to the staged Vite source, as upstream `sync-remote` does
    system "node", "packages/tools/src/index.ts", "brand-vite"

    ENV["LIBSQLITE3_SYS_USE_PKG_CONFIG"] = "1"
    ENV["RUSTC_BOOTSTRAP"] = "1" # workaround to build with stable rust

    # Build with Homebrew pnpm. The staged resources pin their own versions too
    %w[package.json rolldown/package.json vite/package.json].each do |file|
      package_json = buildpath/file
      package_json.atomic_write(JSON.pretty_generate(JSON.parse(package_json.read).except("packageManager")))
    end

    # Point the vendored oxc-node at the workspace's oxc version, as upstream CI does
    system "node", "packages/tools/src/patch-oxc-node.ts"

    # Align the staged Vite's Vitest versions with the lockfile, as upstream CI does
    system "node", "packages/tools/src/vendored-vitest.ts"

    # Vite patches only build-time dependencies, which the production deploy below omits
    (buildpath/"pnpm-workspace.yaml").append_lines "allowUnusedPatches: true"

    system "just", "build"
    system "cargo", "install", *std_cargo_args(path: "crates/vp_global_cli")

    system "pnpm", "--filter=vite-plus", "deploy", "--prod", "--legacy", "--no-optional",
           prefix/"node_modules/vite-plus"
    node_modules = prefix/"node_modules/vite-plus/node_modules"
    # Remove incompatible pre-built `bare-*` binaries. Recurse as `deploy --legacy` writes
    # both the legacy `<name>@<version>` and the current `@/<name>/<version>/<hash>` layouts
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules.glob(".pnpm/**/prebuilds/*")
                .each { |dir| rm_r(dir) if dir.basename.to_s != "#{os}-#{arch}" }
    rm_r node_modules.glob(".pnpm/**/node_modules/fsevents")

    # Symlink vp to vpr and vpx. These are detected at runtime by argv[0]
    bin.install_symlink bin/"vp" => "vpr"
    bin.install_symlink bin/"vp" => "vpx"

    # Generate shell completions, vp uses clap but with a custom env var so we can't use our helper
    (bash_completion/"vp").write Utils.safe_popen_read({ "VP_COMPLETE" => "bash" }, bin/"vp")
    (fish_completion/"vp.fish").write Utils.safe_popen_read({ "VP_COMPLETE" => "fish" }, bin/"vp")
    (zsh_completion/"_vp").write Utils.safe_popen_read({ "VP_COMPLETE" => "zsh" }, bin/"vp")
  end

  test do
    # Use Homebrew node and skip the first-run setup prompt, which stops `vp` on the test PTY
    ENV["VP_NODE_MANAGER"] = "no"

    assert_match version.to_s, shell_output("#{bin}/vp --version")

    # `vp` calls `tcsetattr` on a tty stdin, which stops it with SIGTTOU on the test PTY
    system "#{bin}/vp create vite:application --no-interactive --directory test-app < /dev/null"
    assert_path_exists testpath/"test-app/package.json"

    cd testpath/"test-app" do
      output = shell_output("#{bin}/vp fmt < /dev/null")
      assert_match "Finished", output
    end
  end
end
