class Rustup < Formula
  desc "Rust toolchain installer"
  homepage "https://github.com/rust-lang/rustup"
  url "https://github.com/rust-lang/rustup/archive/refs/tags/1.27.1.tar.gz"
  sha256 "f5ba37f2ba68efec101198dca1585e6e7dd7640ca9c526441b729a79062d3b77"
  license any_of: ["Apache-2.0", "MIT"]
  revision 1
  head "https://github.com/rust-lang/rustup.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "7f6d0e82dc678fd5d76d654e8568063ae6d844bf647a19c1ef5c427776151bd0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "26582463ad820eaa27d0da47d107800898f2a10908a73be36227e72529697a8a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3d52d818014950191f497a00f0a0dffabde39c9e7a188d6e1476d9173f98bc63"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c9f17a7aaca93101e2d8dd1e6fa98ba4ee6dd987fdfeffa396b8a8b0bf755996"
    sha256 cellar: :any_skip_relocation, sonoma:         "ef57ece836e59426b665c4c95ef8f59db8190635f7f825ba22e299f39e14c5c7"
    sha256 cellar: :any_skip_relocation, ventura:        "8592640754f7de0bb6def3179d27cd4a007e8578b5f76370cb2beec4b0458f68"
    sha256 cellar: :any_skip_relocation, monterey:       "6153529df50ce2932ccfcabbeb9a3ab3a032f2ad1868e01e5d4506ba47a4328c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d2a2680e7e8697fa93b216bce8be1633148a9daaadbce3487625e5765992e41f"
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
