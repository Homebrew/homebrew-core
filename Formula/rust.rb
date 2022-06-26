class Rust < Formula
  desc "Safe, concurrent, practical language"
  homepage "https://www.rust-lang.org/"
  license any_of: ["Apache-2.0", "MIT"]

  stable do
    url "https://static.rust-lang.org/dist/rustc-1.61.0-src.tar.gz"
    sha256 "ad0b4351675aa9abdf4c7e066613bd274c4391c5506db152983426376101daed"

    # From https://github.com/rust-lang/rust/tree/#{version}/src/tools
    resource "cargo" do
      url "https://github.com/rust-lang/cargo.git",
          tag:      "0.62.0",
          revision: "a028ae42fc1376571de836be702e840ca8e060c2"
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "fb3d2c526b96d8d78191b93e93c685dfbbbd6d29141f6c8617c3ed65f3eccd1b"
    sha256 cellar: :any,                 arm64_big_sur:  "f7a59420c03269fb7caea1b21e476c0423f7ccd96f26876744f596cbddd1e4d6"
    sha256 cellar: :any,                 monterey:       "ff175ce40ac3b9b119cce952f05df778949fc30425e67129b34ed8f53010ae3f"
    sha256 cellar: :any,                 big_sur:        "64d7f6ca2f8ed1161a5cb39a3e61644f5516fa8434ebb850708b589a063bc4e1"
    sha256 cellar: :any,                 catalina:       "f0b2c6e7eab0222100a6f35270e66a81a50969396f6b9c6d12978c5b1c89fbf9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3c6c242e3ef8a10626aa34058368b9c53fd865b19e18a46b36edeedf43b7944f"
  end

  head do
    url "https://github.com/rust-lang/rust.git"

    resource "cargo" do
      url "https://github.com/rust-lang/cargo.git"
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
      if Hardware::CPU.arm?
        url "https://static.rust-lang.org/dist/2022-04-07/cargo-1.60.0-aarch64-apple-darwin.tar.gz"
        sha256 "6839526ce51c47162e678e6329d90f04b565e2214f9864e15e14fe794d047a73"
      else
        url "https://static.rust-lang.org/dist/2022-04-07/cargo-1.60.0-x86_64-apple-darwin.tar.gz"
        sha256 "fd479595f3c4035a555357c0bebffdf6fb5e244d590dc6b7eb2880dd71091cca"
      end
    end

    on_linux do
      # From: https://github.com/rust-lang/rust/blob/#{version}/src/stage0.json
      url "https://static.rust-lang.org/dist/2022-04-07/cargo-1.60.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "6dfc8b0e2d5ac2ccfc4daff66f1e4ea83af47e491edbc56c867de0227eb0cfd5"
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
    assert_equal "Hello World!\n", `./hello`
    system bin/"cargo", "new", "hello_world", "--bin"
    assert_equal "Hello, world!", cd("hello_world") { shell_output("#{bin}/cargo run").split("\n").last }
  end
end
