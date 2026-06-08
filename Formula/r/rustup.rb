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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "64be4eda51e96b7372ca85f1e9c224a46ed3ff45c1fd6a5f4ec75400d2123841"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "359c352d6b02d76d4a8d7499d12cd887a599432af5b99f334125aa2d7109fe99"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1d751f814b493e7ef4412512219aceaccc4a16974ba88118a35b2734f7641dc7"
    sha256 cellar: :any_skip_relocation, sonoma:        "e68c9a5c36eb99862049114b415a2502aff64fb11e815c4f441e3d21a646c2a5"
    sha256 cellar: :any,                 arm64_linux:   "5f6d0fa5e4cf9be2d1e4e784072a1d54f165e2188c2af262b4d7a889b2dbbb70"
    sha256 cellar: :any,                 x86_64_linux:  "59486bb4ea00d23c54817e5f28220058ae8525deff4d839ee0cf19192541077f"
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

  def post_install
    (HOMEBREW_PREFIX/"bin").install_symlink bin/"rustup"
    (HOMEBREW_PREFIX/"etc/bash_completion.d").install_symlink bash_completion/"rustup"
    (HOMEBREW_PREFIX/"share/zsh/site-functions").install_symlink zsh_completion/"_rustup"
    (HOMEBREW_PREFIX/"share/fish/vendor_completions.d").install_symlink fish_completion/"rustup.fish"
    (HOMEBREW_PREFIX/"share/pwsh/completions").install_symlink pwsh_completion/"_rustup.ps1"

    # Remove the old Homebrew-created symlink during upgrades, but leave any
    # user-managed `rustup-init` file alone.
    rustup_init = HOMEBREW_PREFIX/"bin/rustup-init"
    rustup_init.unlink if rustup_init.symlink? && rustup_init.readlink.to_s.match?(%r{(?:Cellar|opt)/rustup/})
  end

  def caveats
    <<~EOS
      To use rustup, ensure you have "$(brew --prefix rustup)/bin" in your $PATH:
        #{Formatter.url("https://rust-lang.github.io/rustup/installation/already-installed-rust.html")}

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
