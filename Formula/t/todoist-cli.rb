class TodoistCli < Formula
  desc "Official command-line interface for Todoist"
  homepage "https://github.com/todoist/todoist-cli"
  url "https://registry.npmjs.org/@todoist/cli/-/cli-6.1.0.tgz"
  sha256 "1fac6e9465f501c40cfbce4ec3ad2c14756abc84493c27d21e65cabc8fdff92e"
  license "MIT"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_golden_gate: "3fd85b7ed198b8de0168a623514246306493700f6856413907bbd1a9dc9a0b58"
    sha256 cellar: :any,                 arm64_tahoe:       "828b6135fd9cf67b53a732b5df8ad6b0867fa1c4dd1f92475d651455f690bbb0"
    sha256 cellar: :any,                 arm64_sequoia:     "941891924e0d3e77c9572825a8f5348dfaa795914fd951c281adacc52206e656"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "5094806fcaf22146eb0ef4156eb4fac7f5c85c992ddc55ff3f60d22150006587"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "bad5b5d9ae7f7c5f1146d2e8fd5385a5410c55abd447df0eaec9bac3b9367729"
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
