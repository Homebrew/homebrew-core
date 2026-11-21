class TodoistCli < Formula
  desc "Official command-line interface for Todoist"
  homepage "https://github.com/todoist/todoist-cli"
  url "https://registry.npmjs.org/@todoist/cli/-/cli-7.1.0.tgz"
  sha256 "7855ec83b79cd7cb9b64663f70ea4c1fd029bcd2c985d40c82393758158389e0"
  license "MIT"

  bottle do
    manifest_sha256 "902b2643d99cdaed4759bb679680082b8e9defbf39995681d8152a94c6ff6756"
    sha256 cellar: :any,                 arm64_golden_gate: "a34c5008608a9cfa39465fc9560d7046994b72bb1c0d9b61bbb5915be3e38e0a"
    sha256 cellar: :any,                 arm64_tahoe:       "575ce7d93e116cc72cacc6d5f46661ffb7926cf7c0019fd0f3821830ee80803f"
    sha256 cellar: :any,                 arm64_sequoia:     "e53970d74d61c5998b9a40e457630d82ab0b6a9a81ed222d5be55175a576aaad"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "dd93c9ecf3aefab3c3ec3e089c211d34a83757f21cace6575ff56bc7a3ef76aa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "08263130fa78e810c4126aaa6a1e2e35f6a0287852de46e4c22d56b8361cc09c"
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
