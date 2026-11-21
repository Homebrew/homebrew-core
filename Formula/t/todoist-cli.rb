class TodoistCli < Formula
  desc "Official command-line interface for Todoist"
  homepage "https://github.com/todoist/todoist-cli"
  url "https://registry.npmjs.org/@todoist/cli/-/cli-7.0.2.tgz"
  sha256 "5832fdf3420e588ef2c7031dd9310dddd7d30a63310f2bd7cfcc688694c626f2"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_golden_gate: "453748d7e91aaa44ff69ada60b3ce8a92b6c95d9128d89c6feb8763d49bc8f1b"
    sha256 cellar: :any,                 arm64_tahoe:       "6be1f14d98e16a1574e794a298544b2549940115a177864fc219ccb9b240ac2d"
    sha256 cellar: :any,                 arm64_sequoia:     "079b5122d4b94e27b1aa561e423065dcdb828d19bc0c9c671b7b9a1efafdee33"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "ab2477538e5a0a000d4a51dbb45dab29b4987f293c6d3d001d73fb343b981ad5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "d4581d5b5419315a2075260514396975696b9b96ef551f97e2b0196abd5f4747"
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
