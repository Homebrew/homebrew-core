class RustNightly < Formula
  desc "Nightly release of the safe, concurrent, practical language"
  homepage "https://www.rust-lang.org/"
  # Please do not update this more frequently than once a month unless
  # newer features are absolutely needed. This formula exists mainly to
  # allow us to build software which needs features from nightly.
  url "https://static.rust-lang.org/dist/2019-08-25/rustc-nightly-src.tar.xz"
  version "2019-08-25"
  sha256 "069825474ed405c293d706a55608e766e1fde1a21f13385b54326b32a629cfb6"

  keg_only :versioned_formula

  depends_on "cmake" => :build
  depends_on "libssh2"
  depends_on "openssl"
  depends_on "pkg-config"

  resource "cargo" do
    url "https://github.com/rust-lang/cargo.git",
        # Latest commit from 2019-08-25 to match the rustc tarball
        :revision => "475a23e98d8e09af3df8df8adfcf8b9cce11944a"
  end

  resource "cargobootstrap" do
    # From https://github.com/rust-lang/rust/blob/#{version}/src/stage0.txt
    url "https://static.rust-lang.org/dist/2019-05-14/cargo-0.35.0-x86_64-apple-darwin.tar.gz"
    sha256 "e16d48fff7fc9907bb38f06b5cc496b7e3c3de803615604405591bdfbc4aec94"
  end

  def install
    # Fix build failure for compiler_builtins "error: invalid deployment target
    # for -stdlib=libc++ (requires OS X 10.7 or later)"
    ENV["MACOSX_DEPLOYMENT_TARGET"] = MacOS.version

    # Ensure that the `openssl` crate picks up the intended library.
    # https://crates.io/crates/openssl#manual-configuration
    ENV["OPENSSL_DIR"] = Formula["openssl"].opt_prefix

    # Fix build failure for cmake v0.1.24 "error: internal compiler error:
    # src/librustc/ty/subst.rs:127: impossible case reached" on 10.11, and for
    # libgit2-sys-0.6.12 "fatal error: 'os/availability.h' file not found
    # #include <os/availability.h>" on 10.11 and "SecTrust.h:170:67: error:
    # expected ';' after top level declarator" among other errors on 10.12
    ENV["SDKROOT"] = MacOS.sdk_path

    system "./configure", "--prefix=#{prefix}", "--release-channel=nightly"
    system "make"
    system "make", "install"

    resource("cargobootstrap").stage do
      system "./install.sh", "--prefix=#{buildpath}/cargobootstrap"
    end
    ENV.prepend_path "PATH", buildpath/"cargobootstrap/bin"

    resource("cargo").stage do
      ENV["RUSTC"] = bin/"rustc"
      system "cargo", "install", "--root", prefix, "--path", ".", "--features", "curl-sys/force-system-lib-on-osx"
    end

    # Remove any binary files; as Homebrew will run ranlib on them and barf.
    rm_rf Dir["src/{llvm-project,llvm-emscripten,test,librustdoc,etc/snapshot.pyc}"]
    (pkgshare/"rust_src").install Dir["src/*"]

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
    system "#{bin}/rustdoc", "-h"
    (testpath/"hello.rs").write <<~EOS
      fn main() {
        println!("Hello World!");
      }
    EOS
    system "#{bin}/rustc", "hello.rs"
    assert_equal "Hello World!\n", `./hello`
    system "#{bin}/cargo", "new", "hello_world", "--bin"
    assert_equal "Hello, world!",
                 (testpath/"hello_world").cd { `#{bin}/cargo run`.split("\n").last }
  end
end
