class TodoistCli < Formula
  desc "Official command-line interface for Todoist"
  homepage "https://github.com/Doist/todoist-cli"
  url "https://registry.npmjs.org/@doist/todoist-cli/-/todoist-cli-5.9.0.tgz"
  sha256 "720dbfbec8a1b7781da5888c41cae43a1a79a6f85d352fd9842350bde30ed205"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_golden_gate: "1c19c135aa06977fe95fe114c3ef1e7a619c5d4956c470d8cd855605e18e367a"
    sha256 cellar: :any,                 arm64_tahoe:       "1c19c135aa06977fe95fe114c3ef1e7a619c5d4956c470d8cd855605e18e367a"
    sha256 cellar: :any,                 arm64_sequoia:     "1c19c135aa06977fe95fe114c3ef1e7a619c5d4956c470d8cd855605e18e367a"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "f9313203d850fe590ae7597b58e3da29ab6dd3582f0af0d2e6a41fff408138e7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "cbc16f3a6362fc2cda983de32d7dec0b26c6973afcfeed6c3e09754cf6dccba5"
  end

  depends_on "rust" => :build
  depends_on "node"

  resource "keyring" do
    url "https://github.com/Brooooooklyn/keyring-node/archive/refs/tags/v2.1.2.tar.gz"
    sha256 "b461a450df324a73219c6352186b95e4501b3f9099b876b023c9cdcf1d8cbf9d"

    livecheck do
      url "https://raw.githubusercontent.com/Doist/todoist-cli/v#{LATEST_VERSION}/package-lock.json"
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

    node_modules = libexec/"lib/node_modules/@doist/todoist-cli/node_modules"

    resource("keyring").stage do
      system "cargo", "build", "--lib", "--release"
      dylib = Pathname.pwd/"target/release/libnapi_keyring.dylib"
      node_modules.glob("@doist/cli-core/node_modules/@napi-rs/keyring-darwin-*/*.node").each do |prebuilt|
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
