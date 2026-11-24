class TodoistCli < Formula
  desc "Official command-line interface for Todoist"
  homepage "https://github.com/todoist/todoist-cli"
  url "https://registry.npmjs.org/@todoist/cli/-/cli-7.3.1.tgz"
  sha256 "0776240592b08dcaf3d9acd57e4ce29756014207df13f5a18c10a65442baa90d"
  license "MIT"

  bottle do
    manifest_sha256 "57d68121c810bab49082144a5e70d87ee2369325144efda74915104f0dac7442"
    sha256 cellar: :any,                 arm64_golden_gate: "21934d3b94433cb6d42b3f4ac1d9d4bc286746027a144bdda689e0e18e00c9d9"
    sha256 cellar: :any,                 arm64_tahoe:       "ed2f22257c80ccf520c5564c306d0920b223f62b1335d6e6a75e5a2829ba038b"
    sha256 cellar: :any,                 arm64_sequoia:     "551c7b0b52c0d30a4386f317d11a42824a3423141eca3e2828f9caf86942985d"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "dfe479d01110934d508f635fad5fc78b81f2b435f01f62facc7f0352ee91ff44"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "a9b74a6f26647d63eb0643e4b27c587f105fb877e294b9db8d79395c1bf9c325"
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
