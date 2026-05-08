class VitePlus < Formula
  desc "Unified toolchain and entry point for web development"
  homepage "https://viteplus.dev"
  url "https://github.com/voidzero-dev/vite-plus/archive/refs/tags/v0.1.20.tar.gz"
  sha256 "e30f80e02db792efe6dcb01c325c34047cf9de862254322812ddc1c311f3c187"
  license "MIT"
  head "https://github.com/voidzero-dev/vite-plus.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "a9a8130e83427ce97dbbd73e84e1fbb9caae007619301a995983a118d7d65f2d"
    sha256 cellar: :any, arm64_sequoia: "6b4e7baf4c9e1bdc1715f107ff7f3678eda810f946c0abbf3de8f6b182f6f74f"
    sha256 cellar: :any, arm64_sonoma:  "e8c3e5557da703a78b5f9c3c48ab584c3a4f804956f2688cd8ed5123358a5080"
    sha256 cellar: :any, sonoma:        "0a42eebfbdd826355f0ce77b86268bff4c4c5a6bde65e9b5af934ed3cf68f45d"
    sha256               arm64_linux:   "330dad571fa8db29d9b172e60ce8263388a022647c62d6545693c68656cc1fa3"
    sha256               x86_64_linux:  "28077c4bacf9d10e34b6e987ebaea30b2f22b1795440a53196ded08a1c1cead5"
  end

  depends_on "cmake" => :build
  depends_on "just" => :build
  depends_on "pnpm" => :build
  depends_on "rust" => :build
  depends_on "node"

  resource "rolldown" do
    url "https://github.com/rolldown/rolldown.git",
        revision: "d9d72c37c5b90ae8e8863bb3aadc4c67d13d6e82"
    version "d9d72c37c5b90ae8e8863bb3aadc4c67d13d6e82"

    livecheck do
      url "https://raw.githubusercontent.com/voidzero-dev/vite-plus/refs/tags/v#{LATEST_VERSION}/packages/tools/.upstream-versions.json"
      strategy :json do |json|
        json.dig("rolldown", "hash")
      end
    end
  end

  resource "vite" do
    url "https://github.com/vitejs/vite.git",
        revision: "32c29780404c353f5a7c5ba4d06fc5e676741714"
    version "32c29780404c353f5a7c5ba4d06fc5e676741714"

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
