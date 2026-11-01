class TodoistCli < Formula
  desc "Official command-line interface for Todoist"
  homepage "https://github.com/Doist/todoist-cli"
  url "https://registry.npmjs.org/@doist/todoist-cli/-/todoist-cli-5.8.5.tgz"
  sha256 "d8ed92a650863fc1ec79c6787b7454f9b8792d19ee00cc8b739b56efc495d9d6"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_golden_gate: "021fe66c471f68c71601b9723aa7ca14ff122b7f2b0fba74ac20039aabb9ce5f"
    sha256 cellar: :any,                 arm64_tahoe:       "021fe66c471f68c71601b9723aa7ca14ff122b7f2b0fba74ac20039aabb9ce5f"
    sha256 cellar: :any,                 arm64_sequoia:     "021fe66c471f68c71601b9723aa7ca14ff122b7f2b0fba74ac20039aabb9ce5f"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "f86b656705984bfc51abd02e9209871f0a84565ea02d45096ab84dc5e7a96db7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "0f0f923d0684a0adcda6b87645dc367189ee7a93af43e7d1e005190c7f8074b2"
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
