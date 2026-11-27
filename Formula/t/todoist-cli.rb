class TodoistCli < Formula
  desc "Official command-line interface for Todoist"
  homepage "https://github.com/todoist/todoist-cli"
  url "https://registry.npmjs.org/@todoist/cli/-/cli-7.5.3.tgz"
  sha256 "17a848d12ce02fed2a425f8fb92f87da23a1749727846c57d75e3e34875c74ed"
  license "MIT"

  bottle do
    manifest_sha256 "2ba872dbd6d2ef7b77c1b10c69988186ba7adf1ddcbd2990decebc111b86f4ec"
    sha256 cellar: :any,                 arm64_golden_gate: "515d1be122af24970e7c873234372ad916cffa331eb0c8acd87f8a9fbf559380"
    sha256 cellar: :any,                 arm64_tahoe:       "4016be64e8768c53a1a51f71ad508711389e837005e22cbff2dbdfce4980831b"
    sha256 cellar: :any,                 arm64_sequoia:     "1a544e19c9bd204f09acfcf127b0a51935aa254b601aa05b0a48df66592b57fa"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "357d3e82a1babe88970cee1f8db45aed799e34c4efa793e81d3e14dc7bcc0bab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "5bdbdc99ddb4c7b858a757d10ecb9438a286fc101606540cb72d947524dbb83e"
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
