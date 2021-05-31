class Rust < Formula
  desc "Safe, concurrent, practical language"
  homepage "https://www.rust-lang.org/"
  license any_of: ["Apache-2.0", "MIT"]

  stable do
    url "https://static.rust-lang.org/dist/rustc-1.52.1-src.tar.gz"
    sha256 "3a6f23a26d0e8f87abbfbf32c5cd7daa0c0b71d0986abefc56b9a5fbfbd0bf98"

    resource "cargo" do
      url "https://github.com/rust-lang/cargo.git",
          tag:      "0.53.0",
          revision: "69767412acbf7f64773427b1fb53e45296712c3c"
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
        url "https://static.rust-lang.org/dist/2021-03-25/cargo-1.51.0-aarch64-apple-darwin.tar.gz"
        sha256 "3eb0eb6192635c4b844deb97004a7e38a631bb4507b1284c055df8533c00e77a"
      else
        url "https://static.rust-lang.org/dist/2021-03-25/cargo-1.51.0-x86_64-apple-darwin.tar.gz"
        sha256 "37eb709e5ed8fe02d2c8d89bc0be3dc1d642cff223c25df311ff5a82eab53d4b"
      end
    end

    on_linux do
      # From: https://github.com/rust-lang/rust/blob/#{version}/src/stage0.txt
      url "https://static.rust-lang.org/dist/2021-03-25/cargo-1.51.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "fe8abe2c2b467ac5f5021ff8020eda70de9e9f8f45b4a2e834afbd3b78323a31"
    end
  end

  def install
    ENV.prepend_path "PATH", Formula["python@3.9"].opt_libexec/"bin"

    # Fix build failure for compiler_builtins "error: invalid deployment target
    # for -stdlib=libc++ (requires OS X 10.7 or later)"
    on_macos { ENV["MACOSX_DEPLOYMENT_TARGET"] = MacOS.version }

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
