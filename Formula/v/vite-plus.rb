class VitePlus < Formula
  desc "Unified toolchain and entry point for web development"
  homepage "https://viteplus.dev"
  url "https://github.com/voidzero-dev/vite-plus/archive/refs/tags/v0.2.6.tar.gz"
  sha256 "a4d9708adf1356bd1aca433969cb80a14d4bb0ddbaaad604dee1819ac8cb2169"
  license "MIT"
  head "https://github.com/voidzero-dev/vite-plus.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "e258b16e477392da666edc3fe318483d83e1fff8b9eddd9ddacd9ef3f77a33d2"
    sha256 cellar: :any, arm64_sequoia: "c6b7fe7b280b8ff628bdc1da4ea171ab89f36ad4d24a1a138487d073fc50d110"
    sha256 cellar: :any, arm64_sonoma:  "2840a9e66279fa4ce1f17a988361d9da287c1efaf76672e9dbd1c5d4bfb5249f"
    sha256 cellar: :any, sonoma:        "449a1f007153571d07643a281132534a7d8b5bd05731afbded80ccbd66bc0548"
    sha256               arm64_linux:   "93c5c0b8663ab1cccd27cd7d3e2a193e67313cfcadeb18d531df4c5d82e622ad"
    sha256               x86_64_linux:  "fe5f36eaa0cce9fe4dc593db014a89d657ab0e4ef354bd0f612844ab01e08547"
  end

  depends_on "cmake" => :build
  depends_on "just" => :build
  depends_on "pnpm" => :build
  depends_on "rustup" => :build # TODO: try to restore stable rust: https://github.com/voidzero-dev/vite-task/commit/db99ba4d5d33323cc9e7b329f11bdea0610fbc7f
  depends_on "node"

  resource "rolldown" do
    url "https://github.com/rolldown/rolldown.git",
        revision: "03e1e3422cd85495c9863ff3bc3b24212d9f4be2"
    version "03e1e3422cd85495c9863ff3bc3b24212d9f4be2"

    livecheck do
      url "https://raw.githubusercontent.com/voidzero-dev/vite-plus/refs/tags/v#{LATEST_VERSION}/packages/tools/.upstream-versions.json"
      strategy :json do |json|
        json.dig("rolldown", "hash")
      end
    end
  end

  resource "vite" do
    url "https://github.com/vitejs/vite.git",
        revision: "5e7fe129a4dde4f41934083b25e490059985f4e6"
    version "5e7fe129a4dde4f41934083b25e490059985f4e6"

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
