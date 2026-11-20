class TodoistCli < Formula
  desc "Official command-line interface for Todoist"
  homepage "https://github.com/todoist/todoist-cli"
  url "https://registry.npmjs.org/@todoist/cli/-/cli-7.0.0.tgz"
  sha256 "dac3101390acefcd80cacbe98d3048a9684600fd9d339f7496bf4a78e55083cc"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_golden_gate: "739c389a9f57c80b582f9f0857ef6d273462f5b82955371ffbf1d58b016d6ea9"
    sha256 cellar: :any,                 arm64_tahoe:       "bd5522a8bde38b86f939a0b03d8be592e3aadbfe717f09a32e504a6908904463"
    sha256 cellar: :any,                 arm64_sequoia:     "5fee211e1453dadda13b82d8393f05c80618ddcd57d07e821da4566291fd8dc1"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "9d1b24537d19c3ec9f9c67beed7e3c7c437fb83b6f49fa9f21b2964bc94483ed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "2fa31300d5bfed7d4b988048a8d0652e48d0a1ebc0c8a3e5da7085f482f2c345"
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
