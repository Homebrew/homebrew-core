class TodoistCli < Formula
  desc "Official command-line interface for Todoist"
  homepage "https://github.com/todoist/todoist-cli"
  url "https://registry.npmjs.org/@todoist/cli/-/cli-7.4.3.tgz"
  sha256 "19942259efdbc7c387891b5e43bdc1123ea9cb574da4d80f2914cea0fe1a501d"
  license "MIT"

  bottle do
    manifest_sha256 "12cee3ac7cb9c66677b52272b06fc81f5c44d0790148335eda8a6a2b895f594f"
    sha256 cellar: :any,                 arm64_golden_gate: "89d68185e295115d4aee084914f7616a907255929561fbc563da94f0a38b4230"
    sha256 cellar: :any,                 arm64_tahoe:       "2b8817c1dc64e28c379deeec24dc7d5e526a02d7f317a179a98ef7bcd9301ae4"
    sha256 cellar: :any,                 arm64_sequoia:     "1afc9cf4a9ff492935622e02aecae3d0f42bf15b72a7373c8a64e42d4a70af2e"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "37d262692a3af08448432aa7ac6dc683df5bfec55ae1ca3c3504aa5a8a6133bd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "ff18cbb6eeba80b34c4dbe32701b63c6c92436377cc077ea4b854bcf012c4bd5"
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
