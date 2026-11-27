class TodoistCli < Formula
  desc "Official command-line interface for Todoist"
  homepage "https://github.com/todoist/todoist-cli"
  url "https://registry.npmjs.org/@todoist/cli/-/cli-7.5.1.tgz"
  sha256 "49854cffda30013f2b0005c0292d28f1d5b8bd642af702ec55c8fd01d14c6f7a"
  license "MIT"

  bottle do
    manifest_sha256 "f92d10f00de06e682241b684097e42527132a29d35f325e1801669c5316afb47"
    sha256 cellar: :any,                 arm64_golden_gate: "26b789e31f0d4d832dc9cb363856983774650a5e5e99efa409d29916064512aa"
    sha256 cellar: :any,                 arm64_tahoe:       "97e4b74ef2f0edf51beded1bcb265bb7335132ca919acacf8190e416f1813c3a"
    sha256 cellar: :any,                 arm64_sequoia:     "f65d437ed5e81a69e4a78e80b765227c712316add59163c16f2be2a2a5fca988"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "c6147b8f011c7e1c078d139035a0b9804fab0def705e6ff4ddf697ab633c2b0e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "13f94a2262e124cad93955adeef991a0061105435f7d553990b69b3e6c255662"
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
