class TodoistCli < Formula
  desc "Official command-line interface for Todoist"
  homepage "https://github.com/todoist/todoist-cli"
  url "https://registry.npmjs.org/@todoist/cli/-/cli-7.5.0.tgz"
  sha256 "4f060d4fb623e5c38274d05dff2278eb91345d8abe12cc9b97431b8025ca8a23"
  license "MIT"

  bottle do
    manifest_sha256 "058f5e64362379c1272fb66671feb8484bebf7e40e92c7d1aac2dab079940ce9"
    sha256 cellar: :any,                 arm64_golden_gate: "b74a78230197a9255b4d9311fbdc4ae536c0e11051cebfec25f192818d559d86"
    sha256 cellar: :any,                 arm64_tahoe:       "bcf711998479530ff381b8cdbd11631e6252e917f627c8d0808a03458e8228ce"
    sha256 cellar: :any,                 arm64_sequoia:     "2aee25d21bcac5691625f71cbec863138eed87f53bc91dc03a487b3f409ab30b"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "e16b4e9c778ccedab19a780d28bfa3f6cf30675811405e9dccc4e0cf15187390"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "577b76a511bc41e58ef27a8c2f54587e9487b6c183e1afa49e82c3bb3a4bbc57"
  end

  depends_on "rust" => :build
  depends_on "node"

  resource "keyring" do
    url "https://github.com/Brooooooklyn/keyring-node/archive/refs/tags/v2.1.2.tar.gz"
    sha256 "b461a450df324a73219c6352186b95e4501b3f9099b876b023c9cdcf1d8cbf9d"

    livecheck do
      url "https://raw.githubusercontent.com/todoist/todoist-cli/v#{LATEST_VERSION}/package-lock.json"
      regex(/^v?(\d+(?:\.\d+)+)$/i)
      strategy :json do |json, regex|
        json.dig("packages", "node_modules/@napi-rs/keyring", "version")&.[](regex, 1)
      end
    end
  end

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    return unless OS.mac?

    node_modules = libexec/"lib/node_modules/@todoist/cli/node_modules"

    resource("keyring").stage do
      system "cargo", "build", "--lib", "--release"
      dylib = Pathname.pwd/"target/release/libnapi_keyring.dylib"
      node_modules.glob("@napi-rs/keyring-darwin-*/*.node").each do |prebuilt|
        cp dylib, prebuilt
      end
    end

    deuniversalize_machos node_modules/"app-path/main"
  end

  def caveats
    <<~EOS
      Looking for the third-party Go CLI previously published under this
      name (by sachaos)? It has been renamed. Install it with:
        brew install todoist-cli-go
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/td --version")
  end
end
