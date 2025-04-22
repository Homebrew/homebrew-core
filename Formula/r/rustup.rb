class Rustup < Formula
  desc "Rust toolchain installer"
  homepage "https://rust-lang.github.io/rustup/"
  url "https://github.com/rust-lang/rustup/archive/refs/tags/1.28.1.tar.gz"
  sha256 "2def2f9a0a4a21c80f862c0797c2d76e765e0e7237e1e41f28324722ab912bac"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/rust-lang/rustup.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ca99f48302c98be223be9979e5a4bd1ec9aa78ebbbb54392e7d61ea7eebc02a4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ed181c5231c82e89acf5e23177e9f721a2a513bda1c6230e542c5fcbd019da9b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "13b9e160e7e08db280d01c1976745e608feebe4c132a91595c85a897067131b2"
    sha256 cellar: :any_skip_relocation, sonoma:        "5425bf7c4f685d3f1b907b03df1037c3df5dc214fc7ad4baa55dfbd94c463e62"
    sha256 cellar: :any_skip_relocation, ventura:       "d46005331c7c1566d5d5c6da5e29e5677f3a7d171ba64a4895c33da86743edf2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4dcfe6b3852131919ff2ec8adb0b967c83abca11103bcf24a4874d179ee752d7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a6281a03a099d88476ec5ffe2069e8730078125ec0b27e928be6b37b7f247e42"
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
