class Rustup < Formula
  desc "Rust toolchain installer"
  homepage "https://rust-lang.github.io/rustup/"
  url "https://github.com/rust-lang/rustup/archive/refs/tags/1.28.2.tar.gz"
  sha256 "5987dcb828068a4a5e29ba99ab26f2983ac0c6e2e4dc3e5b3a3c0fafb69abbc0"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/rust-lang/rustup.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "64f4ef0c6a93f3f1261e7a83e5e1de535af07109777de50e699d7bc76c5e8e7c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a0dc5a8b36e61ac52cd3c1f2cd8d47fbd31a53ff398b7c1db7b74aa964328e10"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "71920ea5fdebe6673e965ec021c7dc11c5f60f55cb21a308972ea9d339b23109"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "bbd23bbce4c67a64fa453e13e033c282b38e2cc3c6d69de9bebc09463ce31617"
    sha256 cellar: :any_skip_relocation, sonoma:        "03a586bc26e67104067448d73c503074699639aa04eed6504651cfede0efeeef"
    sha256 cellar: :any_skip_relocation, ventura:       "8ebebf2b6d8d8968456fc43b0bab11861d676bdb936efd907791e9f48de9b3bf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "02949aabdf891fe17a36471e9758775efff183255719d33496b89b48a171542e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "36d2915f62a55bffc816e6ffdb7032d6488b8672d1bb556836082eed53943cae"
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
