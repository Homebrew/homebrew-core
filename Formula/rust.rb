class Rust < Formula
  desc "Safe, concurrent, practical language"
  homepage "https://www.rust-lang.org/"
  license any_of: ["Apache-2.0", "MIT"]

  stable do
    url "https://static.rust-lang.org/dist/rustc-1.55.0-src.tar.gz"
    sha256 "b2379ac710f5f876ee3c3e03122fe33098d6765d371cac6c31b1b6fc8e43821e"

    # From https://github.com/rust-lang/rust/tree/#{version}/src/tools
    resource "cargo" do
      url "https://github.com/rust-lang/cargo.git",
          tag:      "0.56.0",
          revision: "32da73ab19417aa89686e1d85c1440b72fdf877d"
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "daee7ff695e32d4da880fa29fac3b17f2d61f36be79bf86dcbada8b1d4399513"
    sha256 cellar: :any,                 big_sur:       "fb31ba5ba6204f6adcb5baafdae3279b4b9c8ab6212cb499f1c7cf2f4e689432"
    sha256 cellar: :any,                 catalina:      "01674095435bd75b6e3c7b0870c1d3b997d65adc2c9dcccb145fe82153af2435"
    sha256 cellar: :any,                 mojave:        "333073da9e0d506a552377a2e57b230f25e985cb4b47b2f5660127bce694387e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "268d461059e68f48fa4e4e51655cf3fdf3e86e09712d5fc59a034881e79dff10"
  end

  head do
    url "https://github.com/rust-lang/rust.git"

    resource "cargo" do
      url "https://github.com/rust-lang/cargo.git"
    end
  end

  depends_on "cmake" => :build
  depends_on "ninja" => :build
  depends_on "python@3.9" => :build
  depends_on "libssh2"
  depends_on "openssl@1.1"
  depends_on "pkg-config"

  uses_from_macos "curl"
  uses_from_macos "zlib"

  resource "cargobootstrap" do
    on_macos do
      # From https://github.com/rust-lang/rust/blob/#{version}/src/stage0.txt
      if Hardware::CPU.arm?
        url "https://static.rust-lang.org/dist/2021-07-29/cargo-1.54.0-aarch64-apple-darwin.tar.gz"
        sha256 "7bac3901d8eb6a4191ffeebe75b29c78bcb270158ec901addb31f588d965d35d"
      else
        url "https://static.rust-lang.org/dist/2021-07-29/cargo-1.54.0-x86_64-apple-darwin.tar.gz"
        sha256 "68564b771c94ed95705ef28ea30bfd917c4b225b476551c998a0b267152cd798"
      end
    end

    on_linux do
      # From: https://github.com/rust-lang/rust/blob/#{version}/src/stage0.txt
      url "https://static.rust-lang.org/dist/2021-07-29/cargo-1.54.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "8c4f404e6fd3e26a535230d1d47d162d0e4a51a0ff82025ae526b5121bdbf6ad"
    end
  end

  def install
    ENV.prepend_path "PATH", Formula["python@3.9"].opt_libexec/"bin"

    # Fix build failure for compiler_builtins "error: invalid deployment target
    # for -stdlib=libc++ (requires OS X 10.7 or later)"
    ENV["MACOSX_DEPLOYMENT_TARGET"] = MacOS.version if OS.mac?

    # Ensure that the `openssl` crate picks up the intended library.
    # https://crates.io/crates/openssl#manual-configuration
    ENV["OPENSSL_DIR"] = Formula["openssl@1.1"].opt_prefix

    args = ["--prefix=#{prefix}"]
    if build.head?
      args << "--disable-rpath"
      args << "--release-channel=nightly"
    else
      args << "--release-channel=stable"
    end

    system "./configure", *args
    system "make"
    system "make", "install"

    resource("cargobootstrap").stage do
      system "./install.sh", "--prefix=#{buildpath}/cargobootstrap"
    end
    ENV.prepend_path "PATH", buildpath/"cargobootstrap/bin"

    resource("cargo").stage do
      ENV["RUSTC"] = bin/"rustc"
      args = %W[--root #{prefix} --path .]
      args += %w[--features curl-sys/force-system-lib-on-osx] if OS.mac?
      system "cargo", "install", *args
      man1.install Dir["src/etc/man/*.1"]
      bash_completion.install "src/etc/cargo.bashcomp.sh"
      zsh_completion.install "src/etc/_cargo"
    end

    (lib/"rustlib/src/rust").install "library"
    rm_rf prefix/"lib/rustlib/uninstall.sh"
    rm_rf prefix/"lib/rustlib/install.log"
  end

  def post_install
    Dir["#{lib}/rustlib/**/*.dylib"].each do |dylib|
      chmod 0664, dylib
      MachO::Tools.change_dylib_id(dylib, "@rpath/#{File.basename(dylib)}")
      chmod 0444, dylib
    end
  end

  test do
    system "#{bin}/rustdoc", "-h"
    (testpath/"hello.rs").write <<~EOS
      fn main() {
        println!("Hello World!");
      }
    EOS
    system "#{bin}/rustc", "hello.rs"
    assert_equal "Hello World!\n", `./hello`
    system "#{bin}/cargo", "new", "hello_world", "--bin"
    assert_equal "Hello, world!",
                 (testpath/"hello_world").cd { `#{bin}/cargo run`.split("\n").last }
  end
end
