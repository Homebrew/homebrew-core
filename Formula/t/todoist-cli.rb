class TodoistCli < Formula
  desc "Official command-line interface for Todoist"
  homepage "https://github.com/Doist/todoist-cli"
  url "https://registry.npmjs.org/@doist/todoist-cli/-/todoist-cli-5.10.1.tgz"
  sha256 "0e10ccd95581f6cb031bf9ee50e69a156502f63cea4c92d77ccd92b68a134c95"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_golden_gate: "b2cc51d576afd522331c704d3bca1fc8de19e96d4e00702d1d040a72a339e2f2"
    sha256 cellar: :any,                 arm64_tahoe:       "b2cc51d576afd522331c704d3bca1fc8de19e96d4e00702d1d040a72a339e2f2"
    sha256 cellar: :any,                 arm64_sequoia:     "b2cc51d576afd522331c704d3bca1fc8de19e96d4e00702d1d040a72a339e2f2"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "98e864c3394923adabebe078ef4db615a275b5f6ddedc1a4aa4bf9f566c46042"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "6426a9c19975af72aef6c4bb71a61e2773b8e2eec89b8a56bc0c63743e43e8a6"
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
