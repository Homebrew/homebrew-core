class Rustup < Formula
  desc "Rust toolchain installer"
  homepage "https://rust-lang.github.io/rustup/"
  url "https://github.com/rust-lang/rustup/archive/refs/tags/1.28.0.tar.gz"
  sha256 "b5172faabef6778322c14f10e96261f0663f8896c7be62109083d57db89a052c"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/rust-lang/rustup.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "22ce2a0b93c70477ccb80f6f1bb4a8dfebe2031bd29e103b26929dece9af24a6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dfcb37c7ac364c0ff2eef8bcbfb5e0e6639b1c50f48e7453631ceb73df2e37cc"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "67a36b5f001c12168baccf909c682709f04f25443f1a67ad3d9edffcdb294400"
    sha256 cellar: :any_skip_relocation, sonoma:        "dc0706102a3510e42ee98aa3d172e122aea62c748d9392f428b571b2e86ea760"
    sha256 cellar: :any_skip_relocation, ventura:       "d2f40289c622b28edebdbd4f40f8336e1fb35359ca1bf120902754090d0a785d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "be1fff8750c2d6fb8e95bc06641ef55703fb478d2932e1891bb02cdcbb791e12"
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

    %w[rustup cargo].each do |name|
      (bash_completion/name).write completion("bash", name)
      (zsh_completion/"_#{name}").write completion("zsh", name)
      (fish_completion/"#{name}.fish").write completion("fish", name) if name != "cargo"
    end
  end

  def completion(shell, command)
    Utils.safe_popen_read(bin/"rustup", "completions", shell, command)
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
