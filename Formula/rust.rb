class Rust < Formula
  desc "Safe, concurrent, practical language"
  homepage "https://www.rust-lang.org/"
  license any_of: ["Apache-2.0", "MIT"]

  stable do
    url "https://static.rust-lang.org/dist/rustc-1.58.1-src.tar.gz"
    sha256 "a839afdd3625d6f3f3c4c10b79813675d1775c460d14be1feaf33a6c829c07c7"

    # From https://github.com/rust-lang/rust/tree/#{version}/src/tools
    resource "cargo" do
      url "https://github.com/rust-lang/cargo.git",
          tag:      "0.59.0",
          revision: "7f08ace4f1305de7f3b1b0e2f765911957226bd4"
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "7095ffb01f86d72954b4d97d0af33cd1920048e523145d02639c39e8d545ded3"
    sha256 cellar: :any,                 arm64_big_sur:  "8a33101af33e589d2a579aba3a783a7ff3849e0a3d38938113c6dd36e7d01887"
    sha256 cellar: :any,                 monterey:       "2612f8b7a49c5e7dc1e53b03c7c1e5e77ad38f945859990900e969f17792bb37"
    sha256 cellar: :any,                 big_sur:        "1cb2b2e0d6e6b642335872ed10c331db90220bf48bcdd6ad5a0c3986af0732d4"
    sha256 cellar: :any,                 catalina:       "d7c3f7ee469f28e7fc56faf3687102835752dee4e57376d33148ab19af8fe681"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b6db491a43bf4b2fde54e080166f9ac7953967d42d98848656d8ccdec774b304"
  end

  head do
    url "https://github.com/rust-lang/rust.git"

    resource "cargo" do
      url "https://github.com/rust-lang/cargo.git"
    end
  end

  depends_on "cmake" => :build
  depends_on "ninja" => :build
  depends_on "python@3.9" => :build
  depends_on "libssh2"
  depends_on "openssl@1.1"
  depends_on "pkg-config"

  uses_from_macos "curl"
  uses_from_macos "zlib"

  resource "cargobootstrap" do
    on_macos do
      # From https://github.com/rust-lang/rust/blob/#{version}/src/stage0.json
      if Hardware::CPU.arm?
        url "https://static.rust-lang.org/dist/2021-12-02/cargo-1.57.0-aarch64-apple-darwin.tar.gz"
        sha256 "2171ecf2c18fadd90588252aa294272aeb740f065772076ef36d04b1b4bfcc4e"
      else
        url "https://static.rust-lang.org/dist/2021-12-02/cargo-1.57.0-x86_64-apple-darwin.tar.gz"
        sha256 "26129f0e3ecd42e730f62d9c693e1a89aedfe6b7c8108cf970b2f1ed51900fb8"
      end
    end

    on_linux do
      # From: https://github.com/rust-lang/rust/blob/#{version}/src/stage0.json
      url "https://static.rust-lang.org/dist/2021-12-02/cargo-1.57.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "2b341034e4c30bede47a432751935549a28e40b566a1fd4b59c824ccd0a26ff6"
    end
  end

  # Pass `--enable-vendor` to `configure` when this patch is no longer needed.
  # Make sure object files in static archives have distinct names.
  # https://github.com/rust-lang/compiler-builtins/issues/443
  patch :p0, :DATA

  def install
    ENV.prepend_path "PATH", Formula["python@3.9"].opt_libexec/"bin"

    # Ensure that the `openssl` crate picks up the intended library.
    # https://crates.io/crates/openssl#manual-configuration
    ENV["OPENSSL_DIR"] = Formula["openssl@1.1"].opt_prefix

    args = ["--prefix=#{prefix}"]
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
    system "#{bin}/rustdoc", "-h"
    (testpath/"hello.rs").write <<~EOS
      fn main() {
        println!("Hello World!");
      }
    EOS
    system "#{bin}/rustc", "hello.rs"
    assert_equal "Hello World!\n", `./hello`
    system "#{bin}/cargo", "new", "hello_world", "--bin"
    assert_equal "Hello, world!", cd("hello_world") { shell_output("#{bin}/cargo run").split("\n").last }
  end
end

__END__
--- Cargo.lock.orig	2022-01-05 23:36:31.734319021 +0800
+++ Cargo.lock	2022-01-05 23:37:17.531044204 +0800
@@ -658,9 +658,9 @@

 [[package]]
 name = "compiler_builtins"
-version = "0.1.53"
+version = "0.1.55"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "2467ff455350a4df7d02f1ed1449d0279605a763de5d586dcf6aa7d732508bcb"
+checksum = "c9ac60765140c97aaf531dae151a287646b0805ec725805da9e2a3ee31cd501c"
 dependencies = [
  "cc",
  "rustc-std-workspace-core",
