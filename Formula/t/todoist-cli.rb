class TodoistCli < Formula
  desc "Official command-line interface for Todoist"
  homepage "https://github.com/Doist/todoist-cli"
  url "https://registry.npmjs.org/@doist/todoist-cli/-/todoist-cli-5.11.1.tgz"
  sha256 "6583bb6354f2f5fd03fdeb0f17acbba81caf4dd33810ad354750bb9f45819b3b"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_golden_gate: "07186c27aab407a9214264783cb22b4200f80451f45480b7cd61f84d9b4391e1"
    sha256 cellar: :any,                 arm64_tahoe:       "07186c27aab407a9214264783cb22b4200f80451f45480b7cd61f84d9b4391e1"
    sha256 cellar: :any,                 arm64_sequoia:     "07186c27aab407a9214264783cb22b4200f80451f45480b7cd61f84d9b4391e1"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "ca250f5b53cba3aaee1c843b0821306798520aee4b785a101ff1638409a90b35"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "93fe82092509a55b4ff381a757736c40e4bb7c427def7b1f795b84b7a4eb2873"
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
