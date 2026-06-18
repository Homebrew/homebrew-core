class VitePlus < Formula
  desc "Unified toolchain and entry point for web development"
  homepage "https://viteplus.dev"
  url "https://github.com/voidzero-dev/vite-plus/archive/refs/tags/v0.2.1.tar.gz"
  sha256 "30f116d1a8703d36008ef9b3ff19e26ad05b6478468ef3cb4ad37ec013fc7cae"
  license "MIT"
  head "https://github.com/voidzero-dev/vite-plus.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "8665d09f2c8d972a472448884820b9355e41d1aaf7f137586262841cb9552fee"
    sha256 cellar: :any, arm64_sequoia: "b6614e403237661780af51b8672df57617afb04b408723f2854f91d703b9eb59"
    sha256 cellar: :any, arm64_sonoma:  "d60043a4a7937aee0ef96bcbc8b47355b08751ef602467c5798914995af1da92"
    sha256 cellar: :any, sonoma:        "ec02d73c4f1e12a78b8e425d8208d5ab47a12443bc491ec27460da21c7a494ab"
    sha256               arm64_linux:   "f96f5d1ff290ece17662ea4f0ae4a7978326225ffc38409f0212409c54f5fb12"
    sha256               x86_64_linux:  "a64d17555235833cce623249a229ed52885855892276d5c73416d3c0caf2861b"
  end

  depends_on "cmake" => :build
  depends_on "just" => :build
  depends_on "pnpm" => :build
  depends_on "rust" => :build
  depends_on "node"

  resource "rolldown" do
    url "https://github.com/rolldown/rolldown.git",
        revision: "d7f919c18980e6b4a26d06bd071d7cf14cf810a7"
    version "d7f919c18980e6b4a26d06bd071d7cf14cf810a7"

    livecheck do
      url "https://raw.githubusercontent.com/voidzero-dev/vite-plus/refs/tags/v#{LATEST_VERSION}/packages/tools/.upstream-versions.json"
      strategy :json do |json|
        json.dig("rolldown", "hash")
      end
    end
  end

  resource "vite" do
    url "https://github.com/vitejs/vite.git",
        revision: "f94df87ff03b40b65e29bacdc04cc18c7bccaa4a"
    version "f94df87ff03b40b65e29bacdc04cc18c7bccaa4a"

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
    ENV["CARGO_HOME"] = buildpath/".cargo"

    # fspy requires nightly Cargo's `-Z bindeps`.
    # Use a stable-Rust stub to keep the CLI buildable without nightly.
    ENV["RUSTC_BOOTSTRAP"] = "1"

    system "cargo", "fetch", "--locked"

    # Rust 1.96 renamed VaList::next_arg to VaList::arg.
    vite_task_checkout = Pathname(Dir[(buildpath/".cargo/git/checkouts/vite-task-*/5833b37").to_s].first)
    inreplace vite_task_checkout/"crates/fspy_preload_unix/src/interceptions/open.rs", ".next_arg", ".arg"
    inreplace vite_task_checkout/"crates/fspy_preload_unix/src/interceptions/spawn/exec/with_argv.rs",
              ".next_arg", ".arg"

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
