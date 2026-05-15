class VitePlus < Formula
  desc "Unified toolchain and entry point for web development"
  homepage "https://viteplus.dev"
  url "https://github.com/voidzero-dev/vite-plus/archive/refs/tags/v0.1.21.tar.gz"
  sha256 "b568736e52a3d89f0809f4b59d8039c227a3c14f5b8b245360a94899a0e83031"
  license "MIT"
  head "https://github.com/voidzero-dev/vite-plus.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "14e125414b22b04cd18cb9e7e43fedfcf65a127c5757db79b0ebe40cdb0af0dc"
    sha256 cellar: :any, arm64_sequoia: "d0da15892307e54530e8455dc466ac7b357bdfc7d98063d1891b60c8c39e01ee"
    sha256 cellar: :any, arm64_sonoma:  "0523d2febafa06cd15e593a221c8c4610401a61e0448b12cc79a4ed20bb6f6c7"
    sha256 cellar: :any, sonoma:        "6596e27c2c8c0efb87cd39eca545d7c21e285ff4712735381fcdec1990942fbc"
    sha256               arm64_linux:   "80223971591979f8799f2172f5507ebccbcfb0bbb9b059128d3efb7f17aa6485"
    sha256               x86_64_linux:  "eaa4f396fa96c028a02d92b416aba2f7b56810a1a93b4fcbbda680156426b35b"
  end

  depends_on "cmake" => :build
  depends_on "just" => :build
  depends_on "pnpm" => :build
  depends_on "rust" => :build
  depends_on "node"

  resource "rolldown" do
    url "https://github.com/rolldown/rolldown.git",
        revision: "ac5c71025a639d394a0db9c3a921b7eda5d71a88"
    version "ac5c71025a639d394a0db9c3a921b7eda5d71a88"

    livecheck do
      url "https://raw.githubusercontent.com/voidzero-dev/vite-plus/refs/tags/v#{LATEST_VERSION}/packages/tools/.upstream-versions.json"
      strategy :json do |json|
        json.dig("rolldown", "hash")
      end
    end
  end

  resource "vite" do
    url "https://github.com/vitejs/vite.git",
        revision: "66f3194aa8e59924562575f0a98e7f4ae0acdd89"
    version "66f3194aa8e59924562575f0a98e7f4ae0acdd89"

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

    ENV["NPM_CONFIG_MANAGE_PACKAGE_MANAGER_VERSIONS"] = "false"

    # fspy requires nightly Cargo's `-Z bindeps`.
    # Use a stable-Rust stub to keep the CLI buildable without nightly.
    ENV["RUSTC_BOOTSTRAP"] = "1"

    inreplace "crates/vite_global_cli/Cargo.toml", 'version = "0.0.0"', "version = \"#{version}\""

    system "just", "build"
    system "cargo", "install", *std_cargo_args(path: "crates/vite_global_cli")

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
