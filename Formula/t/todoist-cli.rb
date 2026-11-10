class TodoistCli < Formula
  desc "Official command-line interface for Todoist"
  homepage "https://github.com/Doist/todoist-cli"
  url "https://registry.npmjs.org/@doist/todoist-cli/-/todoist-cli-5.12.1.tgz"
  sha256 "11e556ad9074cbd0d9abb44f157a9420017a073fe039450d824956c92d88c718"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_golden_gate: "c4c2f39026ac386b18984bf3099983b631705f8bbb30b7e5df907cd1fdaaeb83"
    sha256 cellar: :any,                 arm64_tahoe:       "c4c2f39026ac386b18984bf3099983b631705f8bbb30b7e5df907cd1fdaaeb83"
    sha256 cellar: :any,                 arm64_sequoia:     "c4c2f39026ac386b18984bf3099983b631705f8bbb30b7e5df907cd1fdaaeb83"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "a328357155ec1f024e182841b3a26b3e67681e82955141d566cc06aced1bb6eb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "bee8c222520d1ad078f703258eb39ff4eb89be65c27f9c4c4bb364d7aa706bf4"
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
