class Rustup < Formula
  desc "Rust toolchain installer"
  homepage "https://rust-lang.github.io/rustup/"
  url "https://github.com/rust-lang/rustup/archive/refs/tags/1.29.0.tar.gz"
  sha256 "de73d1a62f4d5409a2f6bdb1c523d8dc08aa6d9d63588db62493c19ca8f8bf55"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/rust-lang/rustup.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6c25d273bdcfced40a76808858e6817b486513cc8d868860002492670e2fbdb0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8aa9ac9513b9680fedf2d8817d8327408baf7ebe022a97ed8da0e7c703f42e5e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1a425fe59f5a297874f18a28ae6e99d4f9631aeab1cd8d321d83e9861222ae7c"
    sha256 cellar: :any_skip_relocation, sonoma:        "f12b096c790141eb3b7a03cacfa3ba814089b0fd403e1b66456dc7cd033d2383"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2fc2f0762c6d963689677499ad3bf139fc17f4199468c2f7e8a3d1f897672d49"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5181fb2e07be82fb124c2da941b76c45fa3a2199cd49561f4e584d0ee5820a5e"
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
    generate_completions_from_executable(bin/"rustup", "completions")
  end

  def post_install
    (HOMEBREW_PREFIX/"bin").install_symlink bin/"rustup", bin/"rustup-init"
  end

  def caveats
    <<~EOS
      To initialize `rustup`, set a default toolchain:
        rustup default stable

      If you have `rust` installed, ensure you have "$(brew --prefix rustup)/bin"
      before "$(brew --prefix)/bin" in your $PATH:
        #{Formatter.url("https://rust-lang.github.io/rustup/installation/already-installed-rust.html")}
    EOS
  end

  test do
    ENV["CARGO_HOME"] = testpath/".cargo"
    ENV["RUSTUP_HOME"] = testpath/".rustup"
    ENV.prepend_path "PATH", bin

    assert_match "no default is configured", shell_output("#{bin}/rustc --version 2>&1", 1)
    system bin/"rustup", "default", "stable"

    system bin/"cargo", "init", "--bin"
    system bin/"cargo", "fmt"
    system bin/"rustc", "src/main.rs"
    assert_equal "Hello, world!", shell_output("./main").chomp
    assert_empty shell_output("#{bin}/cargo clippy")

    # Check for stale symlinks
    system bin/"rustup-init", "-y"
    bins = bin.glob("*").to_set(&:basename).delete(Pathname("rustup-init"))
    expected = testpath.glob(".cargo/bin/*").to_set(&:basename)
    assert (extra = bins - expected).empty?, "Symlinks need to be removed: #{extra.join(",")}"
    assert (missing = expected - bins).empty?, "Symlinks need to be added: #{missing.join(",")}"
  end
end
