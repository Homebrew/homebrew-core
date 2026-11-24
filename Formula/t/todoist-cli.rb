class TodoistCli < Formula
  desc "Official command-line interface for Todoist"
  homepage "https://github.com/todoist/todoist-cli"
  url "https://registry.npmjs.org/@todoist/cli/-/cli-7.4.0.tgz"
  sha256 "cbca7885b68654f1969b544788e603beed4cac6a2e8dbe1f8103530f93d03f5f"
  license "MIT"

  bottle do
    manifest_sha256 "ca6a03429513eb51614701a861a76be408b47e104dab4520d776babd8e7fb7ac"
    sha256 cellar: :any,                 arm64_golden_gate: "d6072dd0ff2745ea82f8ee07ed1027b00ae9f79d8d2ddbebc6ed7b7b4cbb5f33"
    sha256 cellar: :any,                 arm64_tahoe:       "98de48aaf1182c0074fcfbfdf6842407f054e68e12f7411f8bc44cd1f36ba929"
    sha256 cellar: :any,                 arm64_sequoia:     "34d1ff90c879df8c4038238e60a7d4cc24a11628f994b4849ba77c5d523c764a"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "dd52ba8a37964923e722615748e526b6d369bb13d2c1d3309f910476e84e3d98"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "0d37f5a1c3e5ed211e07ca800558a55f00df03facacc1aa10d66a509aba73d71"
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
