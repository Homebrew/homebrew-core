class TodoistCli < Formula
  desc "Official command-line interface for Todoist"
  homepage "https://github.com/todoist/todoist-cli"
  url "https://registry.npmjs.org/@todoist/cli/-/cli-7.6.0.tgz"
  sha256 "c99ee4b4a704bc4081f6eb6eee7801dee45486876bbab1f0c9766da15f7c5b7e"
  license "MIT"

  bottle do
    manifest_sha256 "93fe44c6dfb7eb98f15e621e9221d5f99db5b1aa7050391867d4e0df16a78b6f"
    sha256 cellar: :any,                 arm64_golden_gate: "4055ce7273b63b6fd047eb40528aeab0f4709ea441c9adaafb844cc640db6a09"
    sha256 cellar: :any,                 arm64_tahoe:       "66dfbddb579c9b308b369cbdf681d774895c6631b7ce7fe9f4cd151439930784"
    sha256 cellar: :any,                 arm64_sequoia:     "5824b0bc9ff54d8fd8c44c60cca0997b8169175a4109792e9c9f9d4849831d8d"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "86aa2d98fc4413bc6d4822de27b5269e65c9bb04271eed7e1e967956b0ad858f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "6f7c8ccdee9ed79bc7aa995d831ca9144df8397f3acf2400897049b388557221"
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
