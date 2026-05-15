class Rustup < Formula
  desc "Rust toolchain installer"
  homepage "https://rust-lang.github.io/rustup/"
  url "https://github.com/rust-lang/rustup/archive/refs/tags/1.29.0.tar.gz"
  sha256 "de73d1a62f4d5409a2f6bdb1c523d8dc08aa6d9d63588db62493c19ca8f8bf55"
  license any_of: ["Apache-2.0", "MIT"]
  compatibility_version 1
  head "https://github.com/rust-lang/rustup.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "19a521c95dbdf554cfbf099448be40f523bfbea161d1736ad192cf89beb28092"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c9d847dcbef495560deb088e50dc43dd7bdf81f5c8e631f981250363b3df805d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ea9ef9d8a8947364c20a9ecec3cface8c9a4b0d5e7e25308663c6b48f3878cd0"
    sha256 cellar: :any_skip_relocation, sonoma:        "33ff8e2f74daa8ecf16698ede00d659d367a92dbc62357aeaa2f280d9b8f3fdd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "44046e67b0a58611beb5fce43a61d522b2e1c13571aab6cfb8e2d1ec34611378"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c8f97a2a8630656873cf63e816e083e58cc9623b839e8188c36cd55c8daea767"
  end

  keg_only "it conflicts with rust"

  depends_on "rust" => :build

  uses_from_macos "curl"
  uses_from_macos "xz"

  on_linux do
    depends_on "pkgconf" => :build
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args(features: "no-self-update")

    %w[cargo cargo-clippy cargo-fmt cargo-miri clippy-driver rls rust-analyzer
       rust-gdb rust-gdbgui rust-lldb rustc rustdoc rustfmt rustup].each do |name|
      bin.install_symlink bin/"rustup-init" => name
    end

    (buildpath/"settings.toml").write <<~TOML
      default_toolchain = "stable"
    TOML
    pkgetc.install "settings.toml"
    bin.env_script_all_files libexec/"bin", RUSTUP_OVERRIDE_UNIX_FALLBACK_SETTINGS: pkgetc/"settings.toml"

    generate_completions_from_executable(libexec/"bin/rustup", "completions")
  end

  def post_install
    (HOMEBREW_PREFIX/"bin").install_symlink bin/"rustup", bin/"rustup-init"
  end

  def caveats
    <<~EOS
      If you have `rust` installed, ensure you have "$(brew --prefix rustup)/bin"
      before "$(brew --prefix)/bin" in your $PATH:
        #{Formatter.url("https://rust-lang.github.io/rustup/installation/already-installed-rust.html")}
    EOS
  end

  test do
    ENV["CARGO_HOME"] = testpath/".cargo"
    ENV["RUSTUP_HOME"] = testpath/".rustup"
    ENV.prepend_path "PATH", bin

    assert_match "stable", shell_output("#{bin}/rustup default")
    assert_match "stable", shell_output("#{bin}/rustc --version 2>&1")

    system bin/"cargo", "new", "--bin", "./app"
    cd "app" do
      system bin/"cargo", "fmt"
      system bin/"rustc", "src/main.rs"
      assert_equal "Hello, world!", shell_output("./main").chomp
      assert_empty shell_output("#{bin}/cargo clippy")
    end

    # Check for stale symlinks
    system bin/"rustup-init", "-y"
    bins = bin.glob("*").to_set(&:basename).delete(Pathname("rustup-init"))
    expected = testpath.glob(".cargo/bin/*").to_set(&:basename)
    assert (extra = bins - expected).empty?, "Symlinks need to be removed: #{extra.join(",")}"
    assert (missing = expected - bins).empty?, "Symlinks need to be added: #{missing.join(",")}"
  end
end
