class TodoistCli < Formula
  desc "Official command-line interface for Todoist"
  homepage "https://github.com/Doist/todoist-cli"
  url "https://registry.npmjs.org/@doist/todoist-cli/-/todoist-cli-5.5.4.tgz"
  sha256 "d6c67ec1dde1e4f768bffd30a2f726f14521f98c830243f32641dbccb7c8e98d"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_golden_gate: "02d2355b81f73642748b0d4c30e883f4d24f2ddb2144f19d1d1e3cc5c3125080"
    sha256 cellar: :any,                 arm64_tahoe:       "c332d933b4a7885520bee1f5a36d93031e2bb63a11369f408849bff1d6c143d0"
    sha256 cellar: :any,                 arm64_sequoia:     "d2fde8743d2949e4b92d8edb05b6fab0ee4f20fd5ea4bfe3cad517cc7b220be9"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "eadfac03526066a5e86cf90d46c2ac35f6cb224b6fea78f15610f19ec338c974"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "443d8e8ed1ec5a49a5e62eb73dacf8f1f407ab204e437d96bc29bc154de058e3"
  end

  depends_on "rust" => :build
  depends_on "node"

  resource "keyring" do
    url "https://github.com/Brooooooklyn/keyring-node/archive/refs/tags/v2.1.1.tar.gz"
    sha256 "b1f4847eb61306e8c4f1a0418bf9e47231e8fdbc41a88631777d5cfa515eaaaf"

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
