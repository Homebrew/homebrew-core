class Rustup < Formula
  desc "Rust toolchain installer"
  homepage "https://rust-lang.github.io/rustup/"
  url "https://github.com/rust-lang/rustup/archive/refs/tags/1.29.0.tar.gz"
  sha256 "de73d1a62f4d5409a2f6bdb1c523d8dc08aa6d9d63588db62493c19ca8f8bf55"
  license any_of: ["Apache-2.0", "MIT"]
  revision 2
  compatibility_version 1
  head "https://github.com/rust-lang/rustup.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6053ea3e9235d17c34d3ab698ac44345169e4c789270f51e6929c2c503b4644f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1a50690a9ebf8736dc495b6c16680e34802ac3d12f5653c986b87dcf5546384d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0256d6c93615b741a4b81a6c6e34c202397e079468e4917b4bf2099b0803b672"
    sha256 cellar: :any_skip_relocation, sonoma:        "0369ffb86c5f5a76c0128e90efe1945e070dbf2532756fc539ed89ae7b378c2a"
    sha256 cellar: :any,                 arm64_linux:   "8ea0b765f548e4fb7e973838599f6bd6b63e54da6412abe4982d17703fccc3a8"
    sha256 cellar: :any,                 x86_64_linux:  "f5dd4c3593e1b5d8acbd6885c10f69e4261dc945ccd903a0517a421444b14734"
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
    symlink "{{bin}}/rustup", "{{HOMEBREW_PREFIX}}/bin/rustup", force: true
    symlink "{{bash_completion}}/rustup", "{{HOMEBREW_PREFIX}}/etc/bash_completion.d/rustup", force: true
    symlink "{{zsh_completion}}/_rustup", "{{HOMEBREW_PREFIX}}/share/zsh/site-functions/_rustup", force: true
    symlink "{{fish_completion}}/rustup.fish", "{{HOMEBREW_PREFIX}}/share/fish/vendor_completions.d/rustup.fish",
            force: true
    symlink "{{pwsh_completion}}/_rustup.ps1", "{{HOMEBREW_PREFIX}}/share/pwsh/completions/_rustup.ps1",
            force: true
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
