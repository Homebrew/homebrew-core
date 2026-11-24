class TodoistCli < Formula
  desc "Official command-line interface for Todoist"
  homepage "https://github.com/todoist/todoist-cli"
  url "https://registry.npmjs.org/@todoist/cli/-/cli-7.1.2.tgz"
  sha256 "95b32c3557e1ba7fa222f2d509fb40cd4718d54719f349080f353f982924573a"
  license "MIT"

  bottle do
    manifest_sha256 "36a29ef87bc410a831a0ceeb94041fa826a45e8df6c21f602264a58483fddcf1"
    sha256 cellar: :any,                 arm64_golden_gate: "cdb8654f34bb1fc07b6868b1491c4fb1bdcd9fc4075c7d3072893b69b41a571f"
    sha256 cellar: :any,                 arm64_tahoe:       "b0be18d3690139798c7d460f54d96c9f783d6b546b33dcaa2cecf9038544805a"
    sha256 cellar: :any,                 arm64_sequoia:     "c7e39062e515595b36166bb07a9d31f9b605b4f78df7cf5213d13099ac40b26a"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "370b8682134e87ebfdcf58783eaf5523e5249a6c462435f6731e6f792a9a8b96"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "3b1b88e579d662f30f5110d022992bb1ca64b1d93a53a1ce90edd696f26c0309"
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
