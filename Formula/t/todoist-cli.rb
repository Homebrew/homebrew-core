class TodoistCli < Formula
  desc "Official command-line interface for Todoist"
  homepage "https://github.com/todoist/todoist-cli"
  url "https://registry.npmjs.org/@todoist/cli/-/cli-7.5.5.tgz"
  sha256 "a55b8a8f2a130ebcc6c4e248364eee4ceea20fcb1d6ba8bd669cdc6afff36359"
  license "MIT"

  bottle do
    manifest_sha256 "d1e223cb189cedb63e592c7f7fd1fc910b46bd9b03e83fffde18ca9644bb2bcd"
    sha256 cellar: :any,                 arm64_golden_gate: "2bfd2c6aa3eaa454da1bb5774ec1627d3b73edb23bc96cdf211e28cde9c45945"
    sha256 cellar: :any,                 arm64_tahoe:       "c286282babdab4045ee3b0d00020d74e2515444786424c26822565b1a43070f5"
    sha256 cellar: :any,                 arm64_sequoia:     "429145136a2bd7f65e51bf2c729e1239da3cbb108d5b0eff6fa2c614317358ff"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "6965ef400a24fff96d29f8ba67a86e80d51f2d17e8e8501095ad89eade1c0a8e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "e040dd2f62f8a2d5c5f3135b21030725dabdd31f2683519fa9740601f64ac128"
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
