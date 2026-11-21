class TodoistCli < Formula
  desc "Official command-line interface for Todoist"
  homepage "https://github.com/todoist/todoist-cli"
  url "https://registry.npmjs.org/@todoist/cli/-/cli-7.0.2.tgz"
  sha256 "5832fdf3420e588ef2c7031dd9310dddd7d30a63310f2bd7cfcc688694c626f2"
  license "MIT"

  bottle do
    manifest_sha256 "6be0809f4d468194955a66726ea79b114f2741bf9859d7b5333bd2847625e93a"
    sha256 cellar: :any,                 arm64_golden_gate: "35261767ed0da38dd464c045719335df1ae741ff0438bd725bedb8f5b08c8528"
    sha256 cellar: :any,                 arm64_tahoe:       "65aec6102f4667057e9c673feac02515e18d82e7fc5473d89925b42fa3b44fd4"
    sha256 cellar: :any,                 arm64_sequoia:     "c30ccd3f873b04db868194ed8ed9ab483e8c476500c1581dfdbe66baac7a9794"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "f0e7ed1006eb3da2136482e7a9ab5411afe00de42c59df7f700edcb367f6aeb4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "7f8f1c2794ba200b573355c346b9ca9d7fa0c3237f5a497d4ca03998d4afd161"
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
