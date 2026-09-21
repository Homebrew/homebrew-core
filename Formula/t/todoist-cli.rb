class TodoistCli < Formula
  desc "Official command-line interface for Todoist"
  homepage "https://github.com/Doist/todoist-cli"
  url "https://registry.npmjs.org/@doist/todoist-cli/-/todoist-cli-5.3.9.tgz"
  sha256 "3c1824021a7b294f279e579fcd45ae5f5d118ba11301c2b6db518e3b44839f19"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_golden_gate: "88eefd57330ce9f696a9ef7f86d9d03f610679a8aacd5773be97bf4c07df1a0c"
    sha256 cellar: :any,                 arm64_tahoe:       "e9f81a3e81c7a2c0d96600f28c5e16cc98af25a89b6edf38ad70eefc5934aa32"
    sha256 cellar: :any,                 arm64_sequoia:     "30d95de91150f071f444b91be0750839662625c6b75b21b22af65bd4fd43a51c"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "8a7faca9522d84d90e02a9e365b9d16c6e3d73ed3a1593be26be407b9415e844"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "cdf6495d639950ad6e7eb15aab80ebd80d275806f037e7f384d1493e6eff80f4"
  end

  depends_on "rust" => :build
  depends_on "node"

  resource "keyring" do
    url "https://github.com/Brooooooklyn/keyring-node/archive/refs/tags/v2.1.0.tar.gz"
    sha256 "dcb0381cf252c577ff5c0c3bb0d5dd0750fd04a528484e5dbfdfb3c1add12467"

    livecheck do
      url "https://raw.githubusercontent.com/Doist/todoist-cli/v#{LATEST_VERSION}/package-lock.json"
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

    node_modules = libexec/"lib/node_modules/@doist/todoist-cli/node_modules"

    resource("keyring").stage do
      system "cargo", "build", "--lib", "--release"
      dylib = Pathname.pwd/"target/release/libnapi_keyring.dylib"
      node_modules.glob("@doist/cli-core/node_modules/@napi-rs/keyring-darwin-*/*.node").each do |prebuilt|
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
