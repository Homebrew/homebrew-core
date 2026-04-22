class VitePlus < Formula
  desc "Unified toolchain and entry point for web development"
  homepage "https://viteplus.dev"
  url "https://github.com/voidzero-dev/vite-plus/archive/refs/tags/v0.1.19.tar.gz"
  sha256 "74a8bfb1f58dfac6662cb6c1cf69fa4cd9a3e709cea8500cf642f4d75548991a"
  license "MIT"
  head "https://github.com/voidzero-dev/vite-plus.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "b1a4012454078dcbb90cad8eb13c14756321976ec0aab11365cc329b9587880f"
    sha256 cellar: :any, arm64_sequoia: "3b8a13b3c71bb9aede8b753ba1e99b594332dca49206a38a7a86b8a7ba6286fa"
    sha256 cellar: :any, arm64_sonoma:  "afb750b18f15a13cfbcf85f32071e65f1cb9d9101d5a52dcf98112ccfa8b44b5"
    sha256 cellar: :any, sonoma:        "6c97868ca7a3aec5af6a9f018c999ef9cb18ec22ea7e37225d266775285fffc3"
    sha256               arm64_linux:   "03224528ea5a8ad10708f285773e996fb1334f61cd92a5419442b809494f0b09"
    sha256               x86_64_linux:  "dfa40a77dcccc8efbe337fd15e0da7c378ed4a1803c3f43f1839c9f5d612488f"
  end

  depends_on "cmake" => :build
  depends_on "just" => :build
  depends_on "pnpm" => :build
  depends_on "rust" => :build
  depends_on "node"

  resource "rolldown" do
    url "https://github.com/rolldown/rolldown.git",
        revision: "edec4facc1c74a87af7f1ccc980488171ff6a04c"
    version "edec4facc1c74a87af7f1ccc980488171ff6a04c"

    livecheck do
      url "https://raw.githubusercontent.com/voidzero-dev/vite-plus/refs/tags/v#{LATEST_VERSION}/packages/tools/.upstream-versions.json"
      strategy :json do |json|
        json.dig("rolldown", "hash")
      end
    end
  end

  resource "vite" do
    url "https://github.com/vitejs/vite.git",
        revision: "6e585dcb05a3b159fba7ae57f7faf0b1eca7a390"
    version "6e585dcb05a3b159fba7ae57f7faf0b1eca7a390"

    livecheck do
      url "https://raw.githubusercontent.com/voidzero-dev/vite-plus/refs/tags/v#{LATEST_VERSION}/packages/tools/.upstream-versions.json"
      strategy :json do |json|
        json.dig("vite", "hash")
      end
    end
  end

  # Fix missing le16toh symbol in `@ast-grep/napi`:
  # https://github.com/voidzero-dev/vite-plus/pull/1437
  patch do
    url "https://github.com/voidzero-dev/vite-plus/commit/6dd682862703100367082594de2b672f84212637.patch?full_index=1"
    sha256 "00480c9e6c12dddff00dc28cd4bab52a76bd1f504c8d83e79b52380baa6b713d"
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
