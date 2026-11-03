class TodoistCli < Formula
  desc "Official command-line interface for Todoist"
  homepage "https://github.com/Doist/todoist-cli"
  url "https://registry.npmjs.org/@doist/todoist-cli/-/todoist-cli-5.9.2.tgz"
  sha256 "38d796bdf958245ee031f0b25400047dda67652a8fd013f75181eb2424c2bc1a"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_golden_gate: "9b4e57e29c7458a6f1be0e9bcae407da30de52dc118bc419507f0a6f9b4ad4c3"
    sha256 cellar: :any,                 arm64_tahoe:       "9b4e57e29c7458a6f1be0e9bcae407da30de52dc118bc419507f0a6f9b4ad4c3"
    sha256 cellar: :any,                 arm64_sequoia:     "9b4e57e29c7458a6f1be0e9bcae407da30de52dc118bc419507f0a6f9b4ad4c3"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "45beb9edbb17c517f196b8c5ac8a2a759aaba24302ebf7f90af26dad6c76fe47"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "47616bddbaf12682b08971639b1d98b65c2b2da7ee5a0001f9adcb82cf867c37"
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
