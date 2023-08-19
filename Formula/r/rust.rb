class Rust < Formula
  desc "Safe, concurrent, practical language"
  homepage "https://www.rust-lang.org/"
  license any_of: ["Apache-2.0", "MIT"]

  stable do
    url "https://static.rust-lang.org/dist/rustc-1.71.1-src.tar.gz"
    sha256 "6fa90d50d1d529a75f6cc349784de57d7ec0ba2419b09bde7d335c25bd4e472e"

    # From https://github.com/rust-lang/rust/tree/#{version}/src/tools
    resource "cargo" do
      url "https://github.com/rust-lang/cargo.git",
          tag:      "0.72.2",
          revision: "1a737af0c83b28c1f249b821a76a19c82696b05a"
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "ebb7606e866133436ba0f6914746dd08ba07551a83887ac475540d705cc45d00"
    sha256 cellar: :any,                 arm64_monterey: "14c396c71bfc85ec4dceb235cc4142b4484c31736b99bf5ee5cc2be9f3d548cd"
    sha256 cellar: :any,                 arm64_big_sur:  "c2cf1974f723423d73588c4bd2d3ffe1d27e88c3e78506aa63da4ceb06b15cdf"
    sha256 cellar: :any,                 ventura:        "cf17622b469fd267981d97613d204196ec3725e54d25561a4e13df3ec9543426"
    sha256 cellar: :any,                 monterey:       "639a24c8f7460ba1c18488505605b05f172879e2b972045cdb38b8dfd809edbe"
    sha256 cellar: :any,                 big_sur:        "e204be3861c7f7df3f9ae0d56ffb1e41f0c865157784eb25933d2510ad0fa5d1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6ab9ba5c6d96bf35e29d7d95756f02c0e29a661e3907b4d08a0e85a6996b4686"
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

  conflicts_with "rust-analyzer", because: "both install `rust-analyzer` binary"
  conflicts_with "rustfmt", because: "both install `cargo-fmt` and `rustfmt` binaries"

  resource "cargobootstrap" do
    on_macos do
      # From https://github.com/rust-lang/rust/blob/#{version}/src/stage0.json
      on_arm do
        url "https://static.rust-lang.org/dist/2023-06-01/cargo-1.70.0-aarch64-apple-darwin.tar.xz"
        sha256 "faa0c57eab1846f4220e0833a167b845799bfc2d43aee819db7e9f5fe7d5a031"
      end
      on_intel do
        url "https://static.rust-lang.org/dist/2023-06-01/cargo-1.70.0-x86_64-apple-darwin.tar.xz"
        sha256 "0aa4661564be110614874812891d29b327eb343d2eb1eaf9862438aa2436f6b5"
      end
    end

    on_linux do
      # From: https://github.com/rust-lang/rust/blob/#{version}/src/stage0.json
      on_arm do
        url "https://static.rust-lang.org/dist/2023-06-01/cargo-1.70.0-aarch64-unknown-linux-gnu.tar.xz"
        sha256 "8fd2d9806f0601feab1485f79e46d1441af2158c68abf56788ff355d5c6b4ab5"
      end
      on_intel do
        url "https://static.rust-lang.org/dist/2023-06-01/cargo-1.70.0-x86_64-unknown-linux-gnu.tar.xz"
        sha256 "650e7a890a52869cd14e2305652bff775aec7fc2cf47fc62cf4a89ff07242333"
      end
    end
  end

  def install
    ENV.prepend_path "PATH", Formula["python@3.11"].opt_libexec/"bin"

    # Ensure that the `openssl` crate picks up the intended library.
    # https://crates.io/crates/openssl#manual-configuration
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix

    if OS.mac?
      # Requires the CLT to be the active developer directory if Xcode is installed
      ENV["SDKROOT"] = MacOS.sdk_path
      # Fix build failure for compiler_builtins "error: invalid deployment target
      # for -stdlib=libc++ (requires OS X 10.7 or later)"
      ENV["MACOSX_DEPLOYMENT_TARGET"] = MacOS.version
    end

    args = %W[--prefix=#{prefix} --sysconfdir=#{etc} --enable-vendor --set rust.jemalloc]
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
      args = %W[--root #{prefix} --path . --force]
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
