class Rust < Formula
  desc "Safe, concurrent, practical language"
  homepage "https://www.rust-lang.org/"
  license any_of: ["Apache-2.0", "MIT"]

  stable do
    url "https://static.rust-lang.org/dist/rustc-1.64.0-src.tar.gz"
    sha256 "b3cd9f481e1a2901bf6f3808d30c69cc4ea80d93c4cc4e2ed52258b180381205"

    # From https://github.com/rust-lang/rust/tree/#{version}/src/tools
    resource "cargo" do
      url "https://github.com/rust-lang/cargo.git",
          tag:      "0.65.0",
          revision: "387270bc7f446d17869c7f208207c73231d6a252"
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "6fb6dbcd5c3ec716e4317e6ca8ee118f855e07f4e9e85f654272ce2d8eba6da8"
    sha256 cellar: :any,                 arm64_big_sur:  "66197a981993cb0e1f55c9df752d0e684ad394ad026ac9e963521d5e97da9dbc"
    sha256 cellar: :any,                 monterey:       "6e93ea5237a1dbb39844b1c6d89bc1fd75582d73a47de137fc564a748e84cbb0"
    sha256 cellar: :any,                 big_sur:        "95e9dafade80bb18989e8210e88db50414a71167d9e19c6d951cea902086e334"
    sha256 cellar: :any,                 catalina:       "bc493cbd2cf8f0f6156363fbfaeccf940b118755e22b905434548559371dd915"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6c835a606710424a49483d196ab45fafbdc7724a6a18d9ea1650e13e812e6cee"
  end

  head do
    url "https://github.com/rust-lang/rust.git", branch: "master"

    resource "cargo" do
      url "https://github.com/rust-lang/cargo.git", branch: "master"
    end
  end

  depends_on "cmake" => :build
  depends_on "ninja" => :build
  depends_on "python@3.10" => :build
  depends_on "libssh2"
  depends_on "openssl@1.1"
  depends_on "pkg-config"

  uses_from_macos "curl"
  uses_from_macos "zlib"

  resource "cargobootstrap" do
    on_macos do
      # From https://github.com/rust-lang/rust/blob/#{version}/src/stage0.json
      on_arm do
        url "https://static.rust-lang.org/dist/2022-08-11/cargo-1.63.0-aarch64-apple-darwin.tar.gz"
        sha256 "4ae53dd1a0c059ba4a02a728c9250c785e39bd4f51550e2d3040e96457db4731"
      end
      on_intel do
        url "https://static.rust-lang.org/dist/2022-08-11/cargo-1.63.0-x86_64-apple-darwin.tar.gz"
        sha256 "91fe0d3477036b0630b09db2a9ef340c29b8be56c48ed244428e2490043ca841"
      end
    end

    on_linux do
      # From: https://github.com/rust-lang/rust/blob/#{version}/src/stage0.json
      url "https://static.rust-lang.org/dist/2022-08-11/cargo-1.63.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "43445b2131cefa466943ed4867876f5835fcb17243a18e1db1c8231417a1b27e"
    end
  end

  def install
    ENV.prepend_path "PATH", Formula["python@3.10"].opt_libexec/"bin"

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
