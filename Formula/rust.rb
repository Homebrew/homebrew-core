class Rust < Formula
  desc "Safe, concurrent, practical language"
  homepage "https://www.rust-lang.org/"
  license any_of: ["Apache-2.0", "MIT"]

  stable do
    url "https://static.rust-lang.org/dist/rustc-1.68.0-src.tar.gz"
    sha256 "eaf4d8b19f23a232a4770fb53ab5e7acdedec11da1d02b0e5d491ca92ca96d62"

    # From https://github.com/rust-lang/rust/tree/#{version}/src/tools
    resource "cargo" do
      url "https://github.com/rust-lang/cargo.git",
          tag:      "0.69.0",
          revision: "115f34552518a2f9b96d740192addbac1271e7e6"
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "df3cbab60fc9a438f060d5042efc4103d3ab8a7b27724f422fbfaec272597a4c"
    sha256 cellar: :any,                 arm64_monterey: "8606b4f6b7e427a6237a546fd45f3f34a2cefdafced6ae23c020a2ba08d14899"
    sha256 cellar: :any,                 arm64_big_sur:  "cee6151bf547e363fdd29ff3008cd65fc3e20c5eb4823a0492520cfd4dfb093e"
    sha256 cellar: :any,                 ventura:        "cb7a5141c59398df791ce4548f9da734467d59a57d06ee63c92e14f2adfde397"
    sha256 cellar: :any,                 monterey:       "165442905d4c1a5eefd1bdd4f102d9cb7af10ce0fabd4c2a9042862ee70e0103"
    sha256 cellar: :any,                 big_sur:        "18628b284c48f003dd713e68950cba61c20d30c524c09b43bb89608d2f45ec82"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "223c48304b05004debb31357860f041a5513a93decb73608ca61db29ea51a138"
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
