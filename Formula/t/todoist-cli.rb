class TodoistCli < Formula
  desc "Official command-line interface for Todoist"
  homepage "https://github.com/Doist/todoist-cli"
  url "https://registry.npmjs.org/@doist/todoist-cli/-/todoist-cli-5.10.0.tgz"
  sha256 "1119e8c192a53cd819b813dc2b5a7f56f08d45542e6a6fff86e523cbbf6aebbe"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_golden_gate: "35e44460645b9938ef3c3e59278e894ea7cd69f5204699ce499d351b0f1f5023"
    sha256 cellar: :any,                 arm64_tahoe:       "35e44460645b9938ef3c3e59278e894ea7cd69f5204699ce499d351b0f1f5023"
    sha256 cellar: :any,                 arm64_sequoia:     "35e44460645b9938ef3c3e59278e894ea7cd69f5204699ce499d351b0f1f5023"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "ba8b6753faacf653f13e730d3850526b6a98857cb3b598a17deaa4130b0d0aea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "55f65d00e90f0097c719edf2eee971294b25c84188c7d7629dfa2c18ad32e7a3"
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
