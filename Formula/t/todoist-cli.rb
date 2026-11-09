class TodoistCli < Formula
  desc "Official command-line interface for Todoist"
  homepage "https://github.com/Doist/todoist-cli"
  url "https://registry.npmjs.org/@doist/todoist-cli/-/todoist-cli-5.12.0.tgz"
  sha256 "0cbf90b0e15cf899816a7c2a4a37910713aea9f546118a55b0fd5829fc99e415"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_golden_gate: "2abc93d5b231685844b585fd9869b90a67dc804ede139f5b860d41b172608d32"
    sha256 cellar: :any,                 arm64_tahoe:       "2abc93d5b231685844b585fd9869b90a67dc804ede139f5b860d41b172608d32"
    sha256 cellar: :any,                 arm64_sequoia:     "2abc93d5b231685844b585fd9869b90a67dc804ede139f5b860d41b172608d32"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "e30f93d72ad01a138a58ab25346444ad35b348857eab80f3eb773eb957530d49"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "f6184f2b28ce01d0ba14a4424f72e6bc50d30927f6c17a4a619812b9be3caaf3"
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
