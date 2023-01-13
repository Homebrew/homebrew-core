class Rust < Formula
  desc "Safe, concurrent, practical language"
  homepage "https://www.rust-lang.org/"
  license any_of: ["Apache-2.0", "MIT"]

  stable do
    url "https://static.rust-lang.org/dist/rustc-1.66.1-src.tar.gz"
    sha256 "5b3c933a94c72187705d4ee293198babfdd09442f5937fbd685db3a81f4959ba"

    # From https://github.com/rust-lang/rust/tree/#{version}/src/tools
    resource "cargo" do
      url "https://github.com/rust-lang/cargo.git",
          tag:      "0.67.1",
          revision: "ad779e08be893e57a9e17a810223a3e966f8c0d8"
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
        url "https://static.rust-lang.org/dist/2022-11-03/cargo-1.65.0-aarch64-apple-darwin.tar.gz"
        sha256 "40858f3078b277165c191b6478c2aba7bf0010162273e28e9964404993eba188"
      end
      on_intel do
        url "https://static.rust-lang.org/dist/2022-11-03/cargo-1.65.0-x86_64-apple-darwin.tar.gz"
        sha256 "40cbbd62013130d5208435dc45d6c91703eb6a469b6d8eacf746eedc6974ccc0"
      end
    end

    on_linux do
      # From: https://github.com/rust-lang/rust/blob/#{version}/src/stage0.json
      on_arm do
        url "https://static.rust-lang.org/dist/2022-11-03/cargo-1.65.0-aarch64-unknown-linux-gnu.tar.gz"
        sha256 "406d244def7ea78ed75ca4852498a1b632360626fb5fec69a8442b14ef04aee8"
      end
      on_intel do
        url "https://static.rust-lang.org/dist/2022-11-03/cargo-1.65.0-x86_64-unknown-linux-gnu.tar.gz"
        sha256 "f7d67cf3b34a7d82fa2b22d42ad2aed20ee8f4be95ab97f88b8bf03a397217c2"
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
