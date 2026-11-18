class TodoistCli < Formula
  desc "Official command-line interface for Todoist"
  homepage "https://github.com/todoist/todoist-cli"
  url "https://registry.npmjs.org/@todoist/cli/-/cli-6.2.0.tgz"
  sha256 "a2cda0086f39d78d2ffdaf636fec252d500ec4f654b5210dcecde064233c1ff4"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_golden_gate: "a5428fe9bd7e29b4dae3e2ad736c92d949d93b071f0edc47d3b44108239e9cbe"
    sha256 cellar: :any,                 arm64_tahoe:       "829e46cb014bc000fe49104b60f6e19a16ebde1af78894f163f05f479c05c4b7"
    sha256 cellar: :any,                 arm64_sequoia:     "0d34d748d76b2afc68de45b607b3ecea837bc4fc59d19be88eecc18c96357a9e"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "330b1b01886a063f59c000daef5454f216454469dc98140ccc391e0ecafa5188"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "ec10a3f87d5628c50b36e81aa49d8819b9ace95318a10cf6c53b65f02af83dab"
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
