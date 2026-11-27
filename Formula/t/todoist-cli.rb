class TodoistCli < Formula
  desc "Official command-line interface for Todoist"
  homepage "https://github.com/todoist/todoist-cli"
  url "https://registry.npmjs.org/@todoist/cli/-/cli-7.5.4.tgz"
  sha256 "10c3f197b303b5a794ecb470187d3ada1bc9830c1674fb00495f0a1e44cc8a51"
  license "MIT"

  bottle do
    manifest_sha256 "ce3dfa89c9554ea8f96912871a778d8ea26b3a367b5aa217b2251428225562cd"
    sha256 cellar: :any,                 arm64_golden_gate: "f5dd6df23b1f73e9338c25f1e5eb70f9825f5659e78494ed1d81057abf8f03c3"
    sha256 cellar: :any,                 arm64_tahoe:       "ffe669c2a89f050ccae3a450b954eefb1879b369d2e620d6e18d4c5e22da2e60"
    sha256 cellar: :any,                 arm64_sequoia:     "16c23a297e15a5d751f228547338f6089e8b16ac8b73c90b798257a4af0deec8"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "7355b5bad6953145abddf22d9bfbb994126d414a9354af9535eff20b513719d1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "8004330c4ec025cf1e5ba2ec12b92d6d2a6151f7888d2490946e3d0ee1911874"
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
