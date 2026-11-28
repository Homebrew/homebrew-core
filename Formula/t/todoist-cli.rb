class TodoistCli < Formula
  desc "Official command-line interface for Todoist"
  homepage "https://github.com/todoist/todoist-cli"
  url "https://registry.npmjs.org/@todoist/cli/-/cli-7.6.0.tgz"
  sha256 "c99ee4b4a704bc4081f6eb6eee7801dee45486876bbab1f0c9766da15f7c5b7e"
  license "MIT"

  bottle do
    manifest_sha256 "656d74b150f6c6757d2af4078fe359897b941bf85a19176d0bdfc5d2a531f55d"
    sha256 cellar: :any,                 arm64_golden_gate: "b7a730482f18ac31b3af0933cd5f6866cd82b745af6815f82446a876e83bb36e"
    sha256 cellar: :any,                 arm64_tahoe:       "c02afce23566c262b498ef185aa686a7bcf07c530f600e5c335748f1019ad5a4"
    sha256 cellar: :any,                 arm64_sequoia:     "984de6a5af19464f2fd650e4af84df5ba0a71bb752bb9e4285d98774bb6c7304"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "00a7ab29ff3be5dbdb4e16a66829a390d3b8a6f8448d41d80ddd37c30aab02dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "7dca884fa36b39b6cc1c34f82603580806b7a4c99346131c78c8a6b091c4daa9"
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
