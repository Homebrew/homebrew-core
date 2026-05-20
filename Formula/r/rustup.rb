class Rustup < Formula
  desc "Rust toolchain installer"
  homepage "https://rust-lang.github.io/rustup/"
  url "https://github.com/rust-lang/rustup/archive/refs/tags/1.29.0.tar.gz"
  sha256 "de73d1a62f4d5409a2f6bdb1c523d8dc08aa6d9d63588db62493c19ca8f8bf55"
  license any_of: ["Apache-2.0", "MIT"]
  revision 1
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

    (buildpath/"settings.toml").write <<~TOML
      default_toolchain = "stable"
    TOML
    pkgetc.install "settings.toml"

    # rustup-init is not the recommended way to use this formula.
    # But for backwards compatibility we try to support it the best we can.
    # We are doing three things here:
    # 1. We hide the real binaries behind a symlink so `rustup-init` will install a symlink
    #    to `~/.cargo/bin` rather than copying the binary (which has self-update disabled)
    # 2. Previously, the formula would install `rustup` -> `prefix/bin/rustup-init`
    #    to `~/.cargo/bin` so the shim scripts need to pass through arg0 to retain compatibility.
    # 3. We add a warning to `rustup-init` to recommend using `rustup` directly instead.
    # NOTE: `~/.cargo/bin/rustup` will bypass Homebrew's settings.toml. This is unavoidable.
    (libexec/"bin").install bin/"rustup-init" => "rustup-real"
    (libexec/"bin").install_symlink libexec/"bin/rustup-real" => "rustup"
    (bin/"rustup").write <<~SH
      #!/bin/bash
      export RUSTUP_OVERRIDE_UNIX_FALLBACK_SETTINGS="#{pkgetc}/settings.toml"
      if [[ "$0" == *"rustup-init" ]]; then
        echo "Warning: rustup-init is not the recommended way to use the rustup Homebrew formula." \\
              "Please add \\"\\$(brew --prefix rustup)/bin\\" to your \\$PATH instead." >&2
      fi
      exec -a "$0" "#{opt_libexec}/bin/rustup" "$@"
    SH

    # Install the proxy symlinks - these are the recommended entrypoints for users of this formula,
    # except for `rustup-init` which is for backwards compatibility only.
    %w[cargo cargo-clippy cargo-fmt cargo-miri clippy-driver rls rust-analyzer
       rust-gdb rust-gdbgui rust-lldb rustc rustdoc rustfmt rustup-init].each do |executable|
      bin.install_symlink bin/"rustup" => executable
    end

    generate_completions_from_executable(libexec/"bin/rustup", "completions")
  end

  def post_install
    (HOMEBREW_PREFIX/"bin").install_symlink bin/"rustup", bin/"rustup-init"
  end

  def caveats
    <<~EOS
      To use rustup, ensure you have "$(brew --prefix rustup)/bin" in your $PATH:
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

    # Linux unfortunately doesn't seem to copy symlinks the same way right now.
    return if OS.linux?

    # Check that .cargo/bin/rustup is a symlink pointing to Homebrew's opt prefix for this formula
    rustup_symlink = testpath/".cargo/bin/rustup"
    assert_predicate rustup_symlink, :symlink?
    assert_equal "#{opt_libexec}/bin/rustup", rustup_symlink.readlink.to_s
  end
end
