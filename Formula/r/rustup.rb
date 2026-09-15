class Rustup < Formula
  desc "Rust toolchain installer"
  homepage "https://rust-lang.github.io/rustup/"
  url "https://github.com/rust-lang/rustup/archive/refs/tags/1.29.1.tar.gz"
  sha256 "00f79a02275fd0252be6928d7a44f96bfba706a0cc47a0c85557aa4a875d1181"
  license any_of: ["Apache-2.0", "MIT"]
  compatibility_version 1
  head "https://github.com/rust-lang/rustup.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "b4397d25e9397419b22cb2cfcf72d4b8653bb538c73c40b37696d43a4b3c1ab3"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "964b345d066613eb1fc70c174c101505361db44d206e0e53adc5d05a45fccd94"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "86a5e25e13d485d49880a059a436a6f295d03d1538c7a8801c61615651c23c07"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "76b66db2b3dd40b7e3f8c609e40179bfceaae90e9304b827fed61899c329a1e2"
    sha256 cellar: :any,                 arm64_linux:       "ecbda8ac95f9a8f6588f0f215808e130c2f32dfee677c5d6b41e0585f70c6580"
    sha256 cellar: :any,                 x86_64_linux:      "cdc068158d4d273168c914b9cf6cdba97b223718d3ee03babb8278ae7771a6fb"
  end

  keg_only "it conflicts with rust"

  depends_on "rust" => :build

  uses_from_macos "curl"
  uses_from_macos "xz"

  on_linux do
    depends_on "pkgconf" => :build
    depends_on "openssl@3"
  end

  # Test downloads a Rust toolchain
  allow_network_access! :test

  def fetch
    system "cargo", "fetch", "--locked", "--target", "host-tuple"
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
