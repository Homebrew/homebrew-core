class TodoistCli < Formula
  desc "Official command-line interface for Todoist"
  homepage "https://github.com/todoist/todoist-cli"
  url "https://registry.npmjs.org/@todoist/cli/-/cli-7.6.0.tgz"
  sha256 "c99ee4b4a704bc4081f6eb6eee7801dee45486876bbab1f0c9766da15f7c5b7e"
  license "MIT"
  revision 1

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

  on_linux do
    depends_on "pkgconf" => :build
    depends_on "dbus"
  end

  resource "app-path" do
    on_macos do
      url "https://github.com/sindresorhus/app-path/archive/refs/tags/v4.0.0.tar.gz"
      sha256 "55e8955d8a7748796c753d85056169338abc7b6fc4416fd5aaf89671770efcb2"

      livecheck do
        url "https://raw.githubusercontent.com/todoist/todoist-cli/v#{LATEST_VERSION}/package-lock.json"
        regex(/^v?(\d+(?:\.\d+)+)$/i)
        strategy :json do |json, regex|
          json.dig("packages", "node_modules/app-path", "version")&.[](regex, 1)
        end
      end
    end
  end

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

  resource "npm-lock" do
    url "https://raw.githubusercontent.com/todoist/todoist-cli/v6.1.0/package-lock.json"
    sha256 "f22cda84b50434fc2ab4161b025b95f8d2e386a47604c35ee42313ea005c9736"

    livecheck do
      formula :parent
    end
  end

  deny_network_access!

  def fetch
    buildpath.install resource("npm-lock")
    # npm can keep optional peers of development dependencies with --omit=dev.
    system formula_opt_libexec("node")/"bin/npm", "pkg", "delete", "devDependencies"
    system "npm", "ci", "--omit=dev", "--no-audit", *std_npm_args(prefix: false)

    resource("keyring").stage buildpath/"keyring"
    cd "keyring" do
      if OS.linux?
        # Use Homebrew's D-Bus and prune the unused crates from the lockfile.
        inreplace "Cargo.toml", ', "vendored"', ""
        system "cargo", "update", "--workspace"
      end
      system "cargo", "fetch", *std_cargo_fetch_args
    end
  end

  def install
    node_modules = buildpath/"node_modules"
    rm_r node_modules.glob("@napi-rs/keyring-*")
    arch = Hardware::CPU.arm? ? "arm64" : "x64"
    keyring_target = OS.mac? ? "darwin-#{arch}" : "linux-#{arch}-gnu"

    cd "keyring" do
      system "cargo", "build", "--lib", "--release", "--locked", "--offline"
      cp "target/release/#{shared_library("libnapi_keyring")}",
         node_modules/"@napi-rs/keyring/keyring.#{keyring_target}.node"
    end

    app_path = node_modules/"app-path/main"
    if OS.mac?
      resource("app-path").stage do
        system ENV.cc, "main.m", "-fmodules", "-framework", "AppKit", "-o", app_path
      end
    else
      rm app_path
    end

    libexec.install "CHANGELOG.md", "dist", "node_modules", "package.json", "scripts"
    chmod 0755, libexec/"dist/index.js"
    bin.install_symlink libexec/"dist/index.js" => "td"
  end

  def caveats
    <<~EOS
      Looking for the third-party Go CLI previously published under this
      name (by sachaos)? It has been renamed. Install it with:
        brew install todoist-cli-go
    EOS
  end

  test do
    assert_match "#{version} (", shell_output("#{bin}/td changelog --count 1")
    system "node", "-e", "require(process.argv[1])", libexec/"node_modules/@napi-rs/keyring"
  end
end
