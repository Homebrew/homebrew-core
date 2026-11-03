class TodoistCli < Formula
  desc "Official command-line interface for Todoist"
  homepage "https://github.com/Doist/todoist-cli"
  url "https://registry.npmjs.org/@doist/todoist-cli/-/todoist-cli-5.9.2.tgz"
  sha256 "38d796bdf958245ee031f0b25400047dda67652a8fd013f75181eb2424c2bc1a"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_golden_gate: "47cc7ae7b1ff3746b759c47e4cafd08a91a9c8220ed342f1e6f862e29230aa97"
    sha256 cellar: :any,                 arm64_tahoe:       "47cc7ae7b1ff3746b759c47e4cafd08a91a9c8220ed342f1e6f862e29230aa97"
    sha256 cellar: :any,                 arm64_sequoia:     "47cc7ae7b1ff3746b759c47e4cafd08a91a9c8220ed342f1e6f862e29230aa97"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "1ffb2c1e1df16f8a98d81ca6fd7910a5397b34c7035c20012bf1b8bbf5b7183a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "695991c6f933db6bf625a2f8154001a2ae71039459f67086c8754e34673e6dd9"
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
