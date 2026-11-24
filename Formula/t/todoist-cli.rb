class TodoistCli < Formula
  desc "Official command-line interface for Todoist"
  homepage "https://github.com/todoist/todoist-cli"
  url "https://registry.npmjs.org/@todoist/cli/-/cli-7.4.0.tgz"
  sha256 "cbca7885b68654f1969b544788e603beed4cac6a2e8dbe1f8103530f93d03f5f"
  license "MIT"

  bottle do
    manifest_sha256 "10596de44f9c19143d8e5cf3e5b4071854380465f85249a862d5c845cdd51fd4"
    sha256 cellar: :any,                 arm64_golden_gate: "7b08794562a0b8cd5c77632c267f9ba6a267a9c7b8b0bf1f256ee068ce33c414"
    sha256 cellar: :any,                 arm64_tahoe:       "e69514d29bb4e6e119832e124ae38142e5bf1274acbf17b0d487cbe6ce6c1ae7"
    sha256 cellar: :any,                 arm64_sequoia:     "d0ed10059e604391892f8bd032bc5b93198703c34cd2bc272b29eb1ed1a38164"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "a5173070764d6bedd93a90c4482d5307ab7b00a503e6eb170b6f2097c781b804"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "6ff12d00f0ce5e15341ae45fe2385ef68274de71a153aef51f91f76b81abf52a"
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
