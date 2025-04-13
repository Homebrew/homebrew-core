class Rustup < Formula
  desc "Rust toolchain installer"
  homepage "https://rust-lang.github.io/rustup/"
  url "https://github.com/rust-lang/rustup/archive/refs/tags/1.28.1.tar.gz"
  sha256 "2def2f9a0a4a21c80f862c0797c2d76e765e0e7237e1e41f28324722ab912bac"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/rust-lang/rustup.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4de3da0ff78d828d97242d4d12cd3619ccd0222203089b0bc1d8c2139a61e1c8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "37d3198bae63857f975f1ab5ca4f5afd2e19e847f443bef91138f9b174739e5f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e00fc2d3c0df30a522f31b471c12c02ee817232f7f0989a6fe415cd70287820b"
    sha256 cellar: :any_skip_relocation, sonoma:        "5fae9c9f2a9ec5ff0a2ba14e74f749fac8a00ddf1f95f8dedcf1943c17cccf57"
    sha256 cellar: :any_skip_relocation, ventura:       "03da72a2b82c5ae620eb15cf1f430e7c966efb12b4c998be5abdfbbeab15930a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ecc530a7d461ab83d6144ee7a458cf17f8466679d486936b7c0b7447faf7f3b9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cf42b2a4095128a2b95f86fbec48f94fe76b1feff89ea57c2b7414a93d57eee5"
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
    system "cargo", "install", "--features=no-self-update", *std_cargo_args

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

      If you also have `rust` installed, make sure that `rustup`'s proxies under
      "$(brew --prefix rustup)/bin" come first in PATH compared to e.g.
      "$(brew --prefix)/bin" to avoid conflicts. See the link below for more details:
      <https://rust-lang.github.io/rustup/installation/already-installed-rust.html>
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
