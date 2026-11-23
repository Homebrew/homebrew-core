class TodoistCli < Formula
  desc "Official command-line interface for Todoist"
  homepage "https://github.com/todoist/todoist-cli"
  url "https://registry.npmjs.org/@todoist/cli/-/cli-7.1.1.tgz"
  sha256 "e8c00e035070f685ee686c2c275e14f27e5c94a882b4e22c6b468da80e34fe87"
  license "MIT"

  bottle do
    manifest_sha256 "8c4f7fa31d065ad70a14d5d37af6138356bd16dc62142e35cf2f0ba500dfdc32"
    sha256 cellar: :any,                 arm64_golden_gate: "49d6d135599fe6d91c329c2bb34d9cecda6c8c975397448ea3ee5bd5ba07e747"
    sha256 cellar: :any,                 arm64_tahoe:       "307af439d7be8e4e8260759783c88c7044ca4d5d9f77e19dd8e4bf7a47cb6da6"
    sha256 cellar: :any,                 arm64_sequoia:     "382cf4a72f9776f0528fa265370c613af3b0b6670e01f8a61ce7e4e99567ee5b"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "0583d431e3ada20f516055516d0dbd503a9d64c893a125f727008c75f73ae5ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "bd323b052485b034862c543dcff3ef6f44041589254b834b9777abac724cf540"
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
