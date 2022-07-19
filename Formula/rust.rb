class Rust < Formula
  desc "Safe, concurrent, practical language"
  homepage "https://www.rust-lang.org/"
  license any_of: ["Apache-2.0", "MIT"]

  stable do
    url "https://static.rust-lang.org/dist/rustc-1.62.1-src.tar.gz"
    sha256 "72acbe6ffcd94f598382a7430b0d85ee8f679e6d0b27f3f566ed1c16c978133f"

    # From https://github.com/rust-lang/rust/tree/#{version}/src/tools
    resource "cargo" do
      url "https://github.com/rust-lang/cargo.git",
          tag:      "0.63.0",
          revision: "a748cf5a3e666bc2dcdf54f37adef8ef22196452"
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "838909e71da85c754493b4cffcd5a092e97a21c2e6abdb0fc8488d002ffb4199"
    sha256 cellar: :any,                 arm64_big_sur:  "51be49f828b0675bfee555e1aacd97bf024e56519e369b987c1e3521164a23b4"
    sha256 cellar: :any,                 monterey:       "ed4f2e41d0b2aa68b68bd419246e112f79540266d5120dfedae360257f4991ca"
    sha256 cellar: :any,                 big_sur:        "0c30f4ffd326072717f64b3a1ff5d5d779a6d4138e1ebb3d3500770fdc29c899"
    sha256 cellar: :any,                 catalina:       "3f6634d5562c089c9b94d3d076877b451a192a4894c1720574dfd9dc45e0f58e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f81a723aaa3c9042ee84273ce5eeb4e7976cb11624d40097d0a2dd87d9ddbc23"
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
      if Hardware::CPU.arm?
        url "https://static.rust-lang.org/dist/2022-05-19/cargo-1.61.0-aarch64-apple-darwin.tar.gz"
        sha256 "8099a35548e1ae4773dbbcbe797301c500ec10236435fde0073f52b4937be6c3"
      else
        url "https://static.rust-lang.org/dist/2022-05-19/cargo-1.61.0-x86_64-apple-darwin.tar.gz"
        sha256 "f2b10ef8c56f37014d2f3e4c36d5e666e3be368d24c597e99cf2e4b21dc40455"
      end
    end

    on_linux do
      # From: https://github.com/rust-lang/rust/blob/#{version}/src/stage0.json
      url "https://static.rust-lang.org/dist/2022-05-19/cargo-1.61.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "c6e108e13ef5e08e71d70685861590f8683090368cab1f4eacfe97677333b2c7"
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
