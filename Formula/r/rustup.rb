class Rustup < Formula
  desc "Rust toolchain installer"
  homepage "https://rust-lang.github.io/rustup/"
  license any_of: ["Apache-2.0", "MIT"]
  revision 1
  compatibility_version 1
  head "https://github.com/rust-lang/rustup.git", branch: "main"

  stable do
    # TODO: Remove curl when release has following:
    # https://github.com/rust-lang/rustup/commit/747057342d4616d6cd2cda6b00826c0ebdd0e671
    url "https://github.com/rust-lang/rustup/archive/refs/tags/1.29.1.tar.gz"
    sha256 "00f79a02275fd0252be6928d7a44f96bfba706a0cc47a0c85557aa4a875d1181"
    uses_from_macos "curl"
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "4b477dd5e5de10a9d1518773de69521f27bf34053e54c5b63c7b60c0b378a8c8"
    sha256 cellar: :any, arm64_tahoe:       "8bc2e3e7547cb990101e554542c85a0f28086ae34be929e23e8a2685222a47ca"
    sha256 cellar: :any, arm64_sequoia:     "f91db8ed2e19c72ec4d4f4bbba0d76aebe8385d358582d59b32d78b4b626ba2c"
    sha256 cellar: :any, arm64_linux:       "466409e46da5082156e59a46fba8150956fb131cd5e02c8b51bf71a36975c148"
    sha256 cellar: :any, x86_64_linux:      "bc6d95ad7ebdf2ba63bd5e1cdc0dce33b45dc90670d28b046c4d7535ce2bb992"
  end

  keg_only "it conflicts with rust"

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "xz"

  on_linux do
    depends_on "openssl@4"
  end

  # Test downloads a Rust toolchain
  allow_network_access! :test

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args(features: "no-self-update")

    # Upstream installs this binary as `rustup-init`, but Homebrew packages
    # `rustup` directly and should not provide a separate installer entrypoint.
    mv bin/"rustup-init", bin/"rustup"

    %w[cargo cargo-clippy cargo-fmt cargo-miri clippy-driver rls rust-analyzer
       rust-gdb rust-gdbgui rust-lldb rustc rustdoc rustfmt].each do |name|
      bin.install_symlink bin/"rustup" => name
    end

    (buildpath/"settings.toml").write <<~TOML
      default_toolchain = "stable"
    TOML
    pkgetc.install "settings.toml"
    bin.env_script_all_files libexec/"bin", RUSTUP_OVERRIDE_UNIX_FALLBACK_SETTINGS: pkgetc/"settings.toml"

    generate_completions_from_executable(libexec/"bin/rustup", "completions", shells: [:bash, :zsh, :fish, :pwsh])
    [:bash, :zsh].each do |shell|
      generate_completions_from_executable(
        libexec/"bin/rustup", "completions", shell.to_s, "cargo",
        shells: [shell], base_name: "cargo", shell_parameter_format: :none
      )
    end
  end

  post_install_steps do
    symlink "{{bin}}/rustup", "{{HOMEBREW_PREFIX}}/bin/rustup", overwrite: true
    symlink "{{bash_completion}}/rustup", "{{HOMEBREW_PREFIX}}/etc/bash_completion.d/rustup", overwrite: true
    symlink "{{zsh_completion}}/_rustup", "{{HOMEBREW_PREFIX}}/share/zsh/site-functions/_rustup", overwrite: true
    symlink "{{fish_completion}}/rustup.fish", "{{HOMEBREW_PREFIX}}/share/fish/vendor_completions.d/rustup.fish",
            overwrite: true
    symlink "{{pwsh_completion}}/_rustup.ps1", "{{HOMEBREW_PREFIX}}/share/pwsh/completions/_rustup.ps1",
            overwrite: true
    remove "{{HOMEBREW_PREFIX}}/bin/rustup-init", symlink_target_contains: "Cellar/rustup/"
    remove "{{HOMEBREW_PREFIX}}/bin/rustup-init", symlink_target_contains: "opt/rustup/"
  end

  def caveats
    <<~EOS
      To use rustup, ensure you have "$(brew --prefix rustup)/bin" in your $PATH:
        https://rust-lang.github.io/rustup/installation/already-installed-rust.html

      This formula no longer provides `rustup-init`.
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

    # Check that Homebrew only exposes the packaged `rustup` entrypoint.
    refute_path_exists bin/"rustup-init"

    # Check for stale symlinks
    testpath.install_symlink libexec/"bin/rustup" => "rustup-init"
    system testpath/"rustup-init", "-y"
    bins = bin.glob("*").to_set(&:basename)
    expected = testpath.glob(".cargo/bin/*").to_set(&:basename)
    assert (extra = bins - expected).empty?, "Symlinks need to be removed: #{extra.join(",")}"
    assert (missing = expected - bins).empty?, "Symlinks need to be added: #{missing.join(",")}"
  end
end
