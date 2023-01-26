class Rust < Formula
  desc "Safe, concurrent, practical language"
  homepage "https://www.rust-lang.org/"
  license any_of: ["Apache-2.0", "MIT"]

  stable do
    url "https://static.rust-lang.org/dist/rustc-1.67.0-src.tar.gz"
    sha256 "d029f14fce45a2ec7a9a605d2a0a40aae4739cb2fdae29ee9f7a6e9025a7fde4"

    # From https://github.com/rust-lang/rust/tree/#{version}/src/tools
    resource "cargo" do
      url "https://github.com/rust-lang/cargo.git",
          tag:      "0.68.0",
          revision: "8ecd4f20a9efb626975ac18a016d480dc7183d9b"
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "7f5e39a6bdf9653a262a4253d8b6a823bf307bddbb199a322dd3bc022e575a78"
    sha256 cellar: :any,                 arm64_monterey: "3b09c1f9686ce6331c6c7bed320fcf38bd16a2c12b4b1b8b9e06b496ab571719"
    sha256 cellar: :any,                 arm64_big_sur:  "65c49cb3b57a9c5e55a8212749b5d2fd302836d18e2f053b9e33f2a9f77622fb"
    sha256 cellar: :any,                 ventura:        "0288f03e170a4e9064e365908c6d7357018b4c155d9a9f6aa8fa6feb4ac157bb"
    sha256 cellar: :any,                 monterey:       "d199b1c6b8f0914bae30ce4391a71453917e7e65fc76b4a02643d7744dc551ed"
    sha256 cellar: :any,                 big_sur:        "5926386542993b5ef066e8bb1c8bad4e6e3a88def27281e5c0943608a6d13eda"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "49e1a14a9d0474886ce020c23f835b25e882d8d0fbcdab521c02ce2bd13d3824"
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
  depends_on "openssl@1.1"
  depends_on "pkg-config"

  uses_from_macos "curl"
  uses_from_macos "zlib"

  resource "cargobootstrap" do
    on_macos do
      # From https://github.com/rust-lang/rust/blob/#{version}/src/stage0.json
      on_arm do
        url "https://static.rust-lang.org/dist/2023-01-10/cargo-1.66.1-aarch64-apple-darwin.tar.gz"
        sha256 "01e83be8ce32e3af5155efde7f3e14b0864c1a73b2e73f03401bd14b67018ad7"
      end
      on_intel do
        url "https://static.rust-lang.org/dist/2023-01-10/cargo-1.66.1-x86_64-apple-darwin.tar.gz"
        sha256 "125d0ec5b5a159f4f3757b4ae9eaa338afb7d38b4e290794b8157ed6ca8ac16f"
      end
    end

    on_linux do
      # From: https://github.com/rust-lang/rust/blob/#{version}/src/stage0.json
      on_arm do
        url "https://static.rust-lang.org/dist/2023-01-10/cargo-1.66.1-aarch64-unknown-linux-gnu.tar.gz"
        sha256 "96a44a8ca403f66573d5a8a56610456ac8c0a075f32a6680f8ec4cfff27aa244"
      end
      on_intel do
        url "https://static.rust-lang.org/dist/2023-01-10/cargo-1.66.1-x86_64-unknown-linux-gnu.tar.gz"
        sha256 "7752e7c5cd12204fe852bcb2a67d7fa9ab037f26dd34ccc3b25253b4c223df19"
      end
    end
  end

  def install
    ENV.prepend_path "PATH", Formula["python@3.11"].opt_libexec/"bin"

    # Ensure that the `openssl` crate picks up the intended library.
    # https://crates.io/crates/openssl#manual-configuration
    ENV["OPENSSL_DIR"] = Formula["openssl@1.1"].opt_prefix

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
