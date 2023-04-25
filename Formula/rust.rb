class Rust < Formula
  desc "Safe, concurrent, practical language"
  homepage "https://www.rust-lang.org/"
  license any_of: ["Apache-2.0", "MIT"]

  stable do
    url "https://static.rust-lang.org/dist/rustc-1.68.2-src.tar.gz"
    sha256 "93339c23f7cd4d0c45db58e18b4c6e16d6070f4277aad9d2492d23294bf32e96"

    # From https://github.com/rust-lang/rust/tree/#{version}/src/tools
    resource "cargo" do
      url "https://github.com/rust-lang/cargo.git",
          tag:      "0.69.1",
          revision: "6feb7c9cfc0c5604732dba75e4c3b2dbea38e8d8"
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "f09bad2c7d946de16f759a7c154bdffafa9b73daeda5db53c7c84e7fd078eb1e"
    sha256 cellar: :any,                 arm64_monterey: "cee1e13a516bcb735ae8d02149bd9b0d30c96dd949586208f334b75d6cb2f543"
    sha256 cellar: :any,                 arm64_big_sur:  "3721191799026cc7602d3ed9c76a0a16d12ab2e7c3dfdf6636cb38e52b2add6b"
    sha256 cellar: :any,                 ventura:        "92f70f134f40a2c9870263356da11d16d0f7c5091ff9d38f7bdf3da2708ab568"
    sha256 cellar: :any,                 monterey:       "5b82306e51cffc6a130b2e4d79368e6da2130503fd891dc687f6d0cf7ad0c0a2"
    sha256 cellar: :any,                 big_sur:        "4139b9dea234d9cca689bbb31d8b394804eb4421c3409a60cdb80f476cb0d9f8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "feadb801911153b7a0b9169b813a8b0e7ef6483f4485bd9bfa2d5b9adc89bf52"
  end

  head do
    url "https://github.com/rust-lang/rust.git", branch: "master"

    resource "cargo" do
      url "https://github.com/rust-lang/cargo.git", branch: "master"
    end
  end

  depends_on "cmake" => :build
  depends_on "ninja" => :build
  depends_on "python@3.11" => :build
  depends_on "openssl@3"
  depends_on "pkg-config"

  uses_from_macos "curl"
  uses_from_macos "zlib"

  resource "cargobootstrap" do
    on_macos do
      # From https://github.com/rust-lang/rust/blob/#{version}/src/stage0.json
      on_arm do
        url "https://static.rust-lang.org/dist/2023-02-09/cargo-1.67.1-aarch64-apple-darwin.tar.gz"
        sha256 "1d5e7ca72fa4a75c1fbe0e2cd87c32e2e0e0d1321e18d3c2097e70ce33ce649a"
      end
      on_intel do
        url "https://static.rust-lang.org/dist/2023-02-09/cargo-1.67.1-x86_64-apple-darwin.tar.gz"
        sha256 "7404d9dccb0f6ae776e5ddea1413bcf42b24ff1415a08b1763575692ef0c397d"
      end
    end

    on_linux do
      # From: https://github.com/rust-lang/rust/blob/#{version}/src/stage0.json
      on_arm do
        url "https://static.rust-lang.org/dist/2023-02-09/cargo-1.67.1-aarch64-unknown-linux-gnu.tar.gz"
        sha256 "e1ab1452572cb78fc7ec88bcadb2fd3e230c72b84d990fd6fc4ec57a24abdb2f"
      end
      on_intel do
        url "https://static.rust-lang.org/dist/2023-02-09/cargo-1.67.1-x86_64-unknown-linux-gnu.tar.gz"
        sha256 "8d9310dc1e8d36ebd8d56ccaddb0c854daddb6b750c147c141be04f0ec6e89f0"
      end
    end
  end

  def install
    ENV.prepend_path "PATH", Formula["python@3.11"].opt_libexec/"bin"

    # Ensure that the `openssl` crate picks up the intended library.
    # https://crates.io/crates/openssl#manual-configuration
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix

    if OS.mac? && MacOS.version <= :sierra
      # Requires the CLT to be the active developer directory if Xcode is installed
      ENV["SDKROOT"] = MacOS.sdk_path
      # Fix build failure for compiler_builtins "error: invalid deployment target
      # for -stdlib=libc++ (requires OS X 10.7 or later)"
      ENV["MACOSX_DEPLOYMENT_TARGET"] = MacOS.version
    end

    args = %W[--prefix=#{prefix} --enable-vendor --set rust.jemalloc]
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
      MachO.codesign!(dylib) if Hardware::CPU.arm?
      chmod 0444, dylib
    end
  end

  test do
    system bin/"rustdoc", "-h"
    (testpath/"hello.rs").write <<~EOS
      fn main() {
        println!("Hello World!");
      }
    EOS
    system bin/"rustc", "hello.rs"
    assert_equal "Hello World!\n", shell_output("./hello")
    system bin/"cargo", "new", "hello_world", "--bin"
    assert_equal "Hello, world!", cd("hello_world") { shell_output("#{bin}/cargo run").split("\n").last }
  end
end
