class TodoistCli < Formula
  desc "Official command-line interface for Todoist"
  homepage "https://github.com/Doist/todoist-cli"
  url "https://registry.npmjs.org/@doist/todoist-cli/-/todoist-cli-5.11.0.tgz"
  sha256 "f0528394aea32193d149fa9a42bbf08d7104bf8dd6c9e63dc11ec19140103c33"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_golden_gate: "f898760a89d979961dc09c790ada8ca9d0e7e694644e3db680642b72b865d12e"
    sha256 cellar: :any,                 arm64_tahoe:       "f898760a89d979961dc09c790ada8ca9d0e7e694644e3db680642b72b865d12e"
    sha256 cellar: :any,                 arm64_sequoia:     "f898760a89d979961dc09c790ada8ca9d0e7e694644e3db680642b72b865d12e"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "917fb725b9a500bec5bcbbb0787f8eb999b73888bac092edc0d0dbc706348662"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "96be1fd374ac7efe3446fb8ab8fe8e45ec808ce5f3629b8fa85df9f60518c393"
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
