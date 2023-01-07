class Rust < Formula
  desc "Safe, concurrent, practical language"
  homepage "https://www.rust-lang.org/"
  license any_of: ["Apache-2.0", "MIT"]

  stable do
    url "https://static.rust-lang.org/dist/rustc-1.66.0-src.tar.gz"
    sha256 "3b3cd3ea5a82a266e75d0b35f0b54c16021576d9eb78d384052175a772935a48"

    # From https://github.com/rust-lang/rust/tree/#{version}/src/tools
    resource "cargo" do
      url "https://github.com/rust-lang/cargo.git",
          tag:      "0.67.0",
          revision: "d65d197ad5c6c09234369f219f943e291d4f04b9"
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "6752423e2055f254c352b912c71ac8b6092770a191c294ab40cf3df623a4b1f3"
    sha256 cellar: :any,                 arm64_monterey: "01bb6094b8cea7742e870d48fb766462616987d3ac9386e8dc3ead2167f07604"
    sha256 cellar: :any,                 arm64_big_sur:  "4bcd071a238b73a66682d3083f6c997ae80d9ef281437f8ff3a65705b5dc428a"
    sha256 cellar: :any,                 ventura:        "4f735aad5f49e5542331caf8a2973ae73ca7d11ac9eb09b4a4168562ce5534ed"
    sha256 cellar: :any,                 monterey:       "9bee0e310361385b0a086dd885e3fa536f0785996639beb6536145d0853df072"
    sha256 cellar: :any,                 big_sur:        "78b68759eef6851ac21d337d23a226d027f31d89ffdd36d38ca2c9b26f340c6c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "45f0b9bbe0dbefab50f13a57f770612b548b6ef3130bf5188ec93d6c83354815"
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
