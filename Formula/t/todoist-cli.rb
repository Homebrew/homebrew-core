class TodoistCli < Formula
  desc "Official command-line interface for Todoist"
  homepage "https://github.com/Doist/todoist-cli"
  url "https://registry.npmjs.org/@doist/todoist-cli/-/todoist-cli-5.9.0.tgz"
  sha256 "720dbfbec8a1b7781da5888c41cae43a1a79a6f85d352fd9842350bde30ed205"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_golden_gate: "0334459efcf1b7b8542ab1c1201e91dead8246ef5956569d5ab6ee14013702b1"
    sha256 cellar: :any,                 arm64_tahoe:       "0334459efcf1b7b8542ab1c1201e91dead8246ef5956569d5ab6ee14013702b1"
    sha256 cellar: :any,                 arm64_sequoia:     "0334459efcf1b7b8542ab1c1201e91dead8246ef5956569d5ab6ee14013702b1"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "884481a1f63eefff5308b7ad9044d6f530ab18a6f5fff79d2af726820edc57f5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "367b31e63669a6b0a82b0f5c03c464a80129df1384cd454574ba0b223670d562"
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
