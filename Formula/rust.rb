class Rust < Formula
  desc "Safe, concurrent, practical language"
  homepage "https://www.rust-lang.org/"
  license any_of: ["Apache-2.0", "MIT"]
  revision 1

  stable do
    url "https://static.rust-lang.org/dist/rustc-1.49.0-src.tar.gz"
    sha256 "b50aefa8df1fdfc9bccafdbf37aee611c8dfe81bf5648d5f43699c50289dc779"

    resource "cargo" do
      url "https://github.com/rust-lang/cargo.git",
          tag:      "0.50.0",
          revision: "d00d64df9f803bf5bba8714ca498d8f9159d07f6"
    end
  end

  bottle do
    cellar :any
    sha256 "1587b770d12751f80df62a225585f14b8b49695205b6e305a25351ee24750251" => :big_sur
    sha256 "b7919ddd88ded38459e7367e3823497848e6c6dac3661e02f06fadbe0924da7a" => :arm64_big_sur
    sha256 "79a71993f6bd900369575448730cc767a2dc6bf26783941f2144520f16806205" => :catalina
    sha256 "b2a5b69b08e333a39ac8742c6abf5d57c1e9aeb12f93e5a3fb97bd4269bbfe4b" => :mojave
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
        url "https://static.rust-lang.org/dist/2020-12-31/cargo-1.49.0-aarch64-apple-darwin.tar.gz"
        sha256 "2bd6eb276193b70b871c594ed74641235c8c4dcd77e9b8f193801c281b55478d"
      else
        url "https://static.rust-lang.org/dist/2020-12-31/cargo-1.49.0-x86_64-apple-darwin.tar.gz"
        sha256 "ab1bcd7840c715832dbe4a2c5cd64882908cc0d0e6686dd6aec43d2e4332a003"
      end
    end

    on_linux do
      # From: https://github.com/rust-lang/rust/blob/#{version}/src/stage0.txt
      url "https://static.rust-lang.org/dist/2020-12-31/cargo-1.49.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "900597323df24703a38f58e40ede5c3f70e105ddc296e2b90efe6fe2895278fe"
    end
  end

  def install
    ENV.prepend_path "PATH", Formula["python@3.9"].opt_libexec/"bin"

    # Fix build failure for compiler_builtins "error: invalid deployment target
    # for -stdlib=libc++ (requires OS X 10.7 or later)"
    ENV["MACOSX_DEPLOYMENT_TARGET"] = MacOS.version

    # Ensure that the `openssl` crate picks up the intended library.
    # https://crates.io/crates/openssl#manual-configuration
    ENV["OPENSSL_DIR"] = Formula["openssl@1.1"].opt_prefix

    # Fix build failure for cmake v0.1.24 "error: internal compiler error:
    # src/librustc/ty/subst.rs:127: impossible case reached" on 10.11, and for
    # libgit2-sys-0.6.12 "fatal error: 'os/availability.h' file not found
    # #include <os/availability.h>" on 10.11 and "SecTrust.h:170:67: error:
    # expected ';' after top level declarator" among other errors on 10.12
    ENV["SDKROOT"] = MacOS.sdk_path

    args = ["--prefix=#{prefix}"]
    if build.head?
      args << "--disable-rpath"
      args << "--release-channel=nightly"
    else
      args << "--release-channel=stable"
    end

    if Hardware::CPU.arm?
      # Fix for 1.49.0-beta, remove when the 2nd stable ARM version is released
      inreplace "src/stage0.txt", "1.48.0", "1.49.0"
      inreplace "src/stage0.txt", "2020-11-19", "2020-12-31"
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
      args = %W[--root #{prefix} --path . --features curl-sys/force-system-lib-on-osx]
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
