class Rust < Formula
  desc "Safe, concurrent, practical language"
  homepage "https://www.rust-lang.org/"
  license any_of: ["Apache-2.0", "MIT"]

  stable do
    url "https://static.rust-lang.org/dist/rustc-1.53.0-src.tar.gz"
    sha256 "5cf7ca39a10f6bf4e0b0bd15e3b9a61ce721f301e12d148262e5ba968ab825b9"

    resource "cargo" do
      url "https://github.com/rust-lang/cargo.git",
          tag:      "0.54.0",
          revision: "4369396ce7d270972955d876eaa4954bea56bcd9"
    end
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "9322cd3fb212941b29c00814f7df98ae5089e33c64da35b04b6c5a78d7318a55"
    sha256 cellar: :any, big_sur:       "e6147d6ca4c244701b3f2cefd473083678834111ae3db499c86a7ceab257967c"
    sha256 cellar: :any, catalina:      "aef878e07eba19a1ffa38a3d766344cae6f9acafc85c1d8dc375255c02e8d791"
    sha256 cellar: :any, mojave:        "998b27b5b81d1aa3283cec32fd5d7a17e7b98e10cd06a661d21653541e3a0bce"
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
        url "https://static.rust-lang.org/dist/2021-05-06/cargo-1.52.0-aarch64-apple-darwin.tar.gz"
        sha256 "86b3d0515e80515fd93612502049e630aeba3478e45c1d6ca765002b4c2e7fd8"
      else
        url "https://static.rust-lang.org/dist/2021-05-06/cargo-1.52.0-x86_64-apple-darwin.tar.gz"
        sha256 "02a4be4aae1c99ca1e325f9dbe4d65eba488fd11338d8620f8df46d010ffbf3a"
      end
    end

    on_linux do
      # From: https://github.com/rust-lang/rust/blob/#{version}/src/stage0.txt
      url "https://static.rust-lang.org/dist/2021-05-06/cargo-1.52.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "85151d458672529692470eb85df30a46a4327e53a7e838ec65587f2c1680d559"
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
      args = %W[--root #{prefix} --path .]
      on_macos do
        args += %w[--features curl-sys/force-system-lib-on-osx]
      end
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
