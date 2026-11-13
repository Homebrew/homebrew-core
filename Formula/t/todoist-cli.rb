class TodoistCli < Formula
  desc "Official command-line interface for Todoist"
  homepage "https://github.com/todoist/todoist-cli"
  url "https://registry.npmjs.org/@todoist/cli/-/cli-6.0.1.tgz"
  sha256 "bbecd398a29fdf49b462d9219d23e9680eb8d994c33fc951b064229b19718a89"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_golden_gate: "fe2a4bcb9b91f1d093ef68a4dc4a8ca0ffc1b71424d1624a6d42d7cac9fe904a"
    sha256 cellar: :any,                 arm64_tahoe:       "509d90a85465b33a1cb4e0b6b29f0ba62b184b5d37545ae5ce7b30070c21fa3a"
    sha256 cellar: :any,                 arm64_sequoia:     "f2fb3b1053292bbb814889c0f9d7ceefba654bfa6b9e568e1786cea0a2a1995b"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "2779b7185b79d48277419a0a86968a591cde98275fc2a95b7df0d11f746a4f55"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "0d648cc9134cc458bb180fb044a7486108d42bef5e2a26c91cb04a2713d1ab7f"
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
