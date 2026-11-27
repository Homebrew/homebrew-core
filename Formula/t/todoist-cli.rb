class TodoistCli < Formula
  desc "Official command-line interface for Todoist"
  homepage "https://github.com/todoist/todoist-cli"
  url "https://registry.npmjs.org/@todoist/cli/-/cli-7.5.5.tgz"
  sha256 "a55b8a8f2a130ebcc6c4e248364eee4ceea20fcb1d6ba8bd669cdc6afff36359"
  license "MIT"

  bottle do
    manifest_sha256 "5c959037c4a0bc291ab22ea247cfbecfb3513c639af0341f3ef2d5d0a3bdf70b"
    sha256 cellar: :any,                 arm64_golden_gate: "a9e08f9405c3091a1f12928111e401b0e58c4b6d5312ce514444716c25f4f51b"
    sha256 cellar: :any,                 arm64_tahoe:       "6efd13d65cad36aec45e8631721ef13c7cc4eed069ee234fe255bc2c69dbd816"
    sha256 cellar: :any,                 arm64_sequoia:     "c9aeb6dd6208818e3e64decfac94470ff3f47e8f430cac1c177ea917bfdadcc8"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "113eccabcbb310d497d0dfa4440e4100ab40c5bcb7eec105e147add48f0440ba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "953eb0e45e49458128762cd9b8d53a980382a9e8cba0a805bb7dae5b5597d390"
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
