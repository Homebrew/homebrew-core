class Rust < Formula
  desc "Safe, concurrent, practical language"
  homepage "https://www.rust-lang.org/"
  license any_of: ["Apache-2.0", "MIT"]
  revision 1

  stable do
    url "https://static.rust-lang.org/dist/rustc-1.57.0-src.tar.gz"
    sha256 "3546f9c3b91b1f8b8efd26c94d6b50312c08210397b4072ed2748e2bd4445c1a"

    # From https://github.com/rust-lang/rust/tree/#{version}/src/tools
    resource "cargo" do
      url "https://github.com/rust-lang/cargo.git",
          tag:      "0.58",
          revision: "b2e52d7cab0a286ee9fcc0c17510b1e72fcb53eb"
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "31914279cd3785ff8f6e820d0c61cf62efb5e3d1c2459c57f88d96fcad76802a"
    sha256 cellar: :any,                 arm64_big_sur:  "e4328e159cb38fba57e3bc5f2374f56f97270329f8ea946a6e72aa9cd6db1ebf"
    sha256 cellar: :any,                 monterey:       "417e15fa20e3fc9e42e9e04f467616bdb382dc3186485b5f7d37499f1164b30c"
    sha256 cellar: :any,                 big_sur:        "360448c98d086edf6075148f2799247f4ec1538371d5c34024f30179d8631d56"
    sha256 cellar: :any,                 catalina:       "34a4c9bd98f13d2a24ea62202de36d5ed84c081d9c09aca33fff370b031f2318"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5fd40a1aebf48b13384c997f42a92be48f145e8e1253b91b17d83c834145274b"
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
        url "https://static.rust-lang.org/dist/2021-11-01/cargo-1.56.1-aarch64-apple-darwin.tar.gz"
        sha256 "6ed30275214e956ee10b03db87b0b4297948fd102d39896cece01669555047ef"
      else
        url "https://static.rust-lang.org/dist/2021-11-01/cargo-1.56.1-x86_64-apple-darwin.tar.gz"
        sha256 "cd60c32d0bb0ed59508df96bebb83cf6f85accb9908fb5d63ca95c983a190cf3"
      end
    end

    on_linux do
      # From: https://github.com/rust-lang/rust/blob/#{version}/src/stage0.json
      url "https://static.rust-lang.org/dist/2021-11-01/cargo-1.56.1-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "c896c033bb1f430c4e200ae8af0f74d792e4909a458086b9597f076e1dcc2ab2"
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
    assert_equal "Hello, world!",
                 (testpath/"hello_world").cd { `#{bin}/cargo run`.split("\n").last }
  end
end

__END__
--- Cargo.lock.orig	2022-01-05 23:36:31.734319021 +0800
+++ Cargo.lock	2022-01-05 23:37:17.531044204 +0800
@@ -658,9 +658,9 @@

 [[package]]
 name = "compiler_builtins"
-version = "0.1.49"
+version = "0.1.55"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "20b1438ef42c655665a8ab2c1c6d605a305f031d38d9be689ddfef41a20f3aa2"
+checksum = "c9ac60765140c97aaf531dae151a287646b0805ec725805da9e2a3ee31cd501c"
 dependencies = [
  "cc",
  "rustc-std-workspace-core",
