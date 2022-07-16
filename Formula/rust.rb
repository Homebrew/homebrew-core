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
    sha256 cellar: :any,                 arm64_monterey: "a559acc618a575bd0e05b3a7f0dc5317556a77cd61ee71caf09eb7e79bf54c01"
    sha256 cellar: :any,                 arm64_big_sur:  "6f57dd20872fd28875ee617c19bad45ed3604de9f5e165be41b56e2937842334"
    sha256 cellar: :any,                 monterey:       "0f1491c1229a80bd1f2842e0015cb249ac8a60675e056539d7a578802ed5375e"
    sha256 cellar: :any,                 big_sur:        "f4c49f6d04d67c4a1089c652bde624a2053d20801f5344964d7d100b55d8ce52"
    sha256 cellar: :any,                 catalina:       "e7fa918240ffb72f1b067666995cab5325b603f3f1ff118868d555fe6fb7ffe4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "29ce31caf9a4fc7c72a3a750f5946ff70db5feb3acd08c0ecf41124b5f50828f"
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
        url "https://static.rust-lang.org/dist/2022-05-19/cargo-1.61.0-aarch64-apple-darwin.tar.gz"
        sha256 "8099a35548e1ae4773dbbcbe797301c500ec10236435fde0073f52b4937be6c3"
      end
      on_intel do
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
