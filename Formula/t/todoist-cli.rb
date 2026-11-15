class TodoistCli < Formula
  desc "Official command-line interface for Todoist"
  homepage "https://github.com/todoist/todoist-cli"
  url "https://registry.npmjs.org/@todoist/cli/-/cli-6.1.0.tgz"
  sha256 "1fac6e9465f501c40cfbce4ec3ad2c14756abc84493c27d21e65cabc8fdff92e"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_golden_gate: "3fd85b7ed198b8de0168a623514246306493700f6856413907bbd1a9dc9a0b58"
    sha256 cellar: :any,                 arm64_tahoe:       "828b6135fd9cf67b53a732b5df8ad6b0867fa1c4dd1f92475d651455f690bbb0"
    sha256 cellar: :any,                 arm64_sequoia:     "941891924e0d3e77c9572825a8f5348dfaa795914fd951c281adacc52206e656"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "5094806fcaf22146eb0ef4156eb4fac7f5c85c992ddc55ff3f60d22150006587"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "bad5b5d9ae7f7c5f1146d2e8fd5385a5410c55abd447df0eaec9bac3b9367729"
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
