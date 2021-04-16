class Rust < Formula
  desc "Safe, concurrent, practical language"
  homepage "https://www.rust-lang.org/"
  license any_of: ["Apache-2.0", "MIT"]

  stable do
    url "https://static.rust-lang.org/dist/rustc-1.51.0-src.tar.gz"
    sha256 "7a6b9bafc8b3d81bbc566e7c0d1f17c9f499fd22b95142f7ea3a8e4d1f9eb847"

    resource "cargo" do
      url "https://github.com/rust-lang/cargo.git",
          tag:      "0.52.0",
          revision: "43b129a20fbf1ede0df411396ccf0c024bf34134"
    end
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "194906f669b54ba323143a02595dbdec6788236b52099e4145e4fac2340c27ce"
    sha256 cellar: :any, big_sur:       "f792ca45d01d474f51a4b2261713aa36d55a9b0ce60329d5a563f9a761f26dd8"
    sha256 cellar: :any, catalina:      "680b81ddcee5049e511b1d5b5da7e8be74df351de96317d033f81c01ab7858cb"
    sha256 cellar: :any, mojave:        "d33f8c8aac0b0d6e3527048fd7f687074046d5ce2d5f84af4c741af5e601e517"
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
        url "https://static.rust-lang.org/dist/2021-02-11/cargo-1.50.0-aarch64-apple-darwin.tar.gz"
        sha256 "19d526ef3518fb0322f809deddbd4208a27d08efa41d2188348f1be8d3bcfe5e"
      else
        url "https://static.rust-lang.org/dist/2021-02-11/cargo-1.50.0-x86_64-apple-darwin.tar.gz"
        sha256 "45640bb1cef40f25ecb4bd2a3bb34fdf884c418e625d4f9c9595d2aca84fad78"
      end
    end

    on_linux do
      # From: https://github.com/rust-lang/rust/blob/#{version}/src/stage0.txt
      url "https://static.rust-lang.org/dist/2021-02-11/cargo-1.50.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "3456cfd9be761907a4d3aae475bd79d93662b7aee4541f28df3d1f7c7d71a034"
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
