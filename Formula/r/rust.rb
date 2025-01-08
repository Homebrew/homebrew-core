class Rust < Formula
  desc "Safe, concurrent, practical language"
  homepage "https://www.rust-lang.org/"
  license any_of: ["Apache-2.0", "MIT"]
  revision 2

  stable do
    url "https://static.rust-lang.org/dist/rustc-1.83.0-src.tar.gz"
    sha256 "722d773bd4eab2d828d7dd35b59f0b017ddf9a97ee2b46c1b7f7fac5c8841c6e"

    # From https://github.com/rust-lang/rust/tree/#{version}/src/tools
    resource "cargo" do
      url "https://github.com/rust-lang/cargo/archive/refs/tags/0.84.0.tar.gz"
      sha256 "8d01b3cba1150ae34e5faec59894a9d4e9b46942b082f2bd4ed441ce417ed979"

      # update to use libgit2 1.9, upstream pr ref,https://github.com/rust-lang/cargo/pull/15018
      patch :DATA
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "c4ad4e7cca47cff44b33a0bd35f45b04c6a07e0e7541507f2d9151b02c91d296"
    sha256 cellar: :any,                 arm64_sonoma:  "e33c46cff673b5e03959f2a50a721219ca899a0867c569c8680ab966378420a6"
    sha256 cellar: :any,                 arm64_ventura: "bdd7fecbb17340264a9a01cc2a82be770c9d789eb6a9b2fe2770e82befd38510"
    sha256 cellar: :any,                 sonoma:        "7c8dbe22159b0e4f4402ed804cc27618d225ffecf40bac6bfc1ac44dbdf49b70"
    sha256 cellar: :any,                 ventura:       "7ab5ebb3f28faf78faeac4a55433a6ac52a9b1898f97c5151ce270b77ed119e7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7776fa4c5f4e94c603f868e8209daee047bb56caccf98249db57f9ce5dfb296d"
  end

  head do
    url "https://github.com/rust-lang/rust.git", branch: "master"

    resource "cargo" do
      url "https://github.com/rust-lang/cargo.git", branch: "master"
    end
  end

  depends_on "libgit2"
  depends_on "libssh2"
  depends_on "llvm"
  depends_on macos: :sierra
  depends_on "openssl@3"
  depends_on "pkgconf"
  depends_on "zstd"

  uses_from_macos "python" => :build
  uses_from_macos "curl"
  uses_from_macos "zlib"

  link_overwrite "etc/bash_completion.d/cargo"
  # These used to belong in `rustfmt`.
  link_overwrite "bin/cargo-fmt", "bin/git-rustfmt", "bin/rustfmt", "bin/rustfmt-*"

  # From https://github.com/rust-lang/rust/blob/#{version}/src/stage0
  resource "rustc-bootstrap" do
    on_macos do
      on_arm do
        url "https://static.rust-lang.org/dist/2024-10-17/rustc-1.82.0-aarch64-apple-darwin.tar.xz", using: :nounzip
        sha256 "ca9b9cab552c86ac7a28d8fb757c95a363bb5d6413b854b19472950eab2a9fa4"
      end
      on_intel do
        url "https://static.rust-lang.org/dist/2024-10-17/rustc-1.82.0-x86_64-apple-darwin.tar.xz", using: :nounzip
        sha256 "f74ade16cc926a240208ec87d02dcb30f6bb29f9ce9b36479bca57a159e6d96b"
      end
    end

    on_linux do
      on_arm do
        url "https://static.rust-lang.org/dist/2024-10-17/rustc-1.82.0-aarch64-unknown-linux-gnu.tar.xz", using: :nounzip
        sha256 "2958e667202819f6ba1ea88a2a36d7b6a49aad7e460b79ebbb5cf9221b96f599"
      end
      on_intel do
        url "https://static.rust-lang.org/dist/2024-10-17/rustc-1.82.0-x86_64-unknown-linux-gnu.tar.xz", using: :nounzip
        sha256 "90b61494f5ccfd4d1ca9a5ce4a0af49a253ca435c701d9c44e3e44b5faf70cb8"
      end
    end
  end

  # From https://github.com/rust-lang/rust/blob/#{version}/src/stage0
  resource "cargo-bootstrap" do
    on_macos do
      on_arm do
        url "https://static.rust-lang.org/dist/2024-10-17/cargo-1.82.0-aarch64-apple-darwin.tar.xz", using: :nounzip
        sha256 "66b9acc4629a21896ebd96076016263461567b8faf4eb0b76d0a72614790f29a"
      end
      on_intel do
        url "https://static.rust-lang.org/dist/2024-10-17/cargo-1.82.0-x86_64-apple-darwin.tar.xz", using: :nounzip
        sha256 "29c43175bcdff3e21f82561ca930f80661136b9aeffbfa6914667992362caad8"
      end
    end

    on_linux do
      on_arm do
        url "https://static.rust-lang.org/dist/2024-10-17/cargo-1.82.0-aarch64-unknown-linux-gnu.tar.xz", using: :nounzip
        sha256 "05c0d904a82cddb8a00b0bbdd276ad7e24dea62a7b6c380413ab1e5a4ed70a56"
      end
      on_intel do
        url "https://static.rust-lang.org/dist/2024-10-17/cargo-1.82.0-x86_64-unknown-linux-gnu.tar.xz", using: :nounzip
        sha256 "97aeae783874a932c4500f4d36473297945edf6294d63871784217d608718e70"
      end
    end
  end

  # From https://github.com/rust-lang/rust/blob/#{version}/src/stage0
  resource "rust-std-bootstrap" do
    on_macos do
      on_arm do
        url "https://static.rust-lang.org/dist/2024-10-17/rust-std-1.82.0-aarch64-apple-darwin.tar.xz", using: :nounzip
        sha256 "8b0786c55e02f3adc5df030861b6b60bc336326b9e372f6b1bf3040257621a90"
      end
      on_intel do
        url "https://static.rust-lang.org/dist/2024-10-17/rust-std-1.82.0-x86_64-apple-darwin.tar.xz", using: :nounzip
        sha256 "5e35d52cb3bd414fbe39f747e0080398f22eba06514c630e3a01e63417b4ca35"
      end
    end

    on_linux do
      on_arm do
        url "https://static.rust-lang.org/dist/2024-10-17/rust-std-1.82.0-aarch64-unknown-linux-gnu.tar.xz", using: :nounzip
        sha256 "1359ac1f3a123ae5da0ee9e47b98bb9e799578eefd9f347ff9bafd57a1d74a7f"
      end
      on_intel do
        url "https://static.rust-lang.org/dist/2024-10-17/rust-std-1.82.0-x86_64-unknown-linux-gnu.tar.xz", using: :nounzip
        sha256 "2eca3d36f7928f877c334909f35fe202fbcecce109ccf3b439284c2cb7849594"
      end
    end
  end

  def llvm
    Formula["llvm"]
  end

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    # https://docs.rs/openssl/latest/openssl/#manual
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix

    ENV["LIBGIT2_NO_VENDOR"] = "1"
    ENV["LIBSSH2_SYS_USE_PKG_CONFIG"] = "1"

    if OS.mac?
      # Requires the CLT to be the active developer directory if Xcode is installed
      ENV["SDKROOT"] = MacOS.sdk_path
      # Fix build failure for compiler_builtins "error: invalid deployment target
      # for -stdlib=libc++ (requires OS X 10.7 or later)"
      ENV["MACOSX_DEPLOYMENT_TARGET"] = MacOS.version
    end

    cargo_src_path = buildpath/"src/tools/cargo"
    rm_r(cargo_src_path)
    resource("cargo").stage cargo_src_path
    if OS.mac?
      inreplace cargo_src_path/"Cargo.toml",
                /^curl\s*=\s*"(.+)"$/,
                'curl = { version = "\\1", features = ["force-system-lib-on-osx"] }'
    end

    cache_date = File.basename(File.dirname(resource("rustc-bootstrap").url))
    build_cache_directory = buildpath/"build/cache"/cache_date

    resource("rustc-bootstrap").stage build_cache_directory
    resource("cargo-bootstrap").stage build_cache_directory
    resource("rust-std-bootstrap").stage build_cache_directory

    # rust-analyzer is available in its own formula.
    tools = %w[
      analysis
      cargo
      clippy
      rustdoc
      rustfmt
      rust-analyzer-proc-macro-srv
      rust-demangler
      src
    ]
    args = %W[
      --prefix=#{prefix}
      --sysconfdir=#{etc}
      --tools=#{tools.join(",")}
      --llvm-root=#{llvm.opt_prefix}
      --enable-llvm-link-shared
      --enable-profiler
      --enable-vendor
      --disable-cargo-native-static
      --disable-docs
      --disable-lld
      --set=rust.jemalloc
      --release-description=#{tap.user}
    ]
    if build.head?
      args << "--disable-rpath"
      args << "--release-channel=nightly"
    else
      args << "--release-channel=stable"
    end

    system "./configure", *args
    system "make"
    system "make", "install"

    bash_completion.install etc/"bash_completion.d/cargo"
    (lib/"rustlib/src/rust").install "library"
    rm([
      bin.glob("*.old"),
      lib/"rustlib/install.log",
      lib/"rustlib/uninstall.sh",
      (lib/"rustlib").glob("manifest-*"),
    ])
  end

  def post_install
    lib.glob("rustlib/**/*.dylib") do |dylib|
      chmod 0664, dylib
      MachO::Tools.change_dylib_id(dylib, "@rpath/#{File.basename(dylib)}")
      MachO.codesign!(dylib) if Hardware::CPU.arm?
      chmod 0444, dylib
    end
    return unless OS.mac?

    # Symlink our LLVM here to make sure the adjacent bin/rust-lld can find it.
    # Needs to be done in `postinstall` to avoid having `change_dylib_id` done on it.
    lib.glob("rustlib/*/lib") do |dir|
      # Use `ln_sf` instead of `install_symlink` to avoid resolving this into a Cellar path.
      ln_sf llvm.opt_lib/shared_library("libLLVM"), dir
    end
  end

  def check_binary_linkage(binary, library)
    binary.dynamically_linked_libraries.any? do |dll|
      next false unless dll.start_with?(HOMEBREW_PREFIX.to_s)

      File.realpath(dll) == File.realpath(library)
    end
  end

  test do
    system bin/"rustdoc", "-h"
    (testpath/"hello.rs").write <<~RUST
      fn main() {
        println!("Hello World!");
      }
    RUST
    system bin/"rustc", "hello.rs"
    assert_equal "Hello World!\n", shell_output("./hello")
    system bin/"cargo", "new", "hello_world", "--bin"
    assert_equal "Hello, world!", cd("hello_world") { shell_output("#{bin}/cargo run").split("\n").last }

    assert_match <<~EOS, shell_output("#{bin}/rustfmt --check hello.rs", 1)
       fn main() {
      -  println!("Hello World!");
      +    println!("Hello World!");
       }
    EOS

    # We only check the tools' linkage here. No need to check rustc.
    expected_linkage = {
      bin/"cargo" => [
        Formula["libgit2"].opt_lib/shared_library("libgit2"),
        Formula["libssh2"].opt_lib/shared_library("libssh2"),
        Formula["openssl@3"].opt_lib/shared_library("libcrypto"),
        Formula["openssl@3"].opt_lib/shared_library("libssl"),
      ],
    }
    unless OS.mac?
      expected_linkage[bin/"cargo"] += [
        Formula["curl"].opt_lib/shared_library("libcurl"),
        Formula["zlib"].opt_lib/shared_library("libz"),
      ]
    end
    missing_linkage = []
    expected_linkage.each do |binary, dylibs|
      dylibs.each do |dylib|
        next if check_binary_linkage(binary, dylib)

        missing_linkage << "#{binary} => #{dylib}"
      end
    end
    assert missing_linkage.empty?, "Missing linkage: #{missing_linkage.join(", ")}"
  end
end

__END__
diff --git a/Cargo.lock b/Cargo.lock
index 404e5d2..4844092 100644
--- a/Cargo.lock
+++ b/Cargo.lock
@@ -1117,9 +1117,9 @@ dependencies = [
 
 [[package]]
 name = "git2"
-version = "0.19.0"
+version = "0.20.0"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "b903b73e45dc0c6c596f2d37eccece7c1c8bb6e4407b001096387c63d0d93724"
+checksum = "3fda788993cc341f69012feba8bf45c0ba4f3291fcc08e214b4d5a7332d88aff"
 dependencies = [
  "bitflags 2.6.0",
  "libc",
@@ -1132,9 +1132,9 @@ dependencies = [
 
 [[package]]
 name = "git2-curl"
-version = "0.20.0"
+version = "0.21.0"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "68ff14527a1c242320039b138376f8e0786697a1b7b172bc44f6efda3ab9079f"
+checksum = "be8dcabbc09ece4d30a9aa983d5804203b7e2f8054a171f792deff59b56d31fa"
 dependencies = [
  "curl",
  "git2",
@@ -2216,9 +2216,9 @@ dependencies = [
 
 [[package]]
 name = "libgit2-sys"
-version = "0.17.0+1.8.1"
+version = "0.18.0+1.9.0"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "10472326a8a6477c3c20a64547b0059e4b0d086869eee31e6d7da728a8eb7224"
+checksum = "e1a117465e7e1597e8febea8bb0c410f1c7fb93b1e1cddf34363f8390367ffec"
 dependencies = [
  "cc",
  "libc",
diff --git a/Cargo.toml b/Cargo.toml
index c797f11..72b8f50 100644
--- a/Cargo.toml
+++ b/Cargo.toml
@@ -46,8 +46,8 @@ curl = "0.4.46"
 curl-sys = "0.4.73"
 filetime = "0.2.23"
 flate2 = { version = "1.0.30", default-features = false, features = ["zlib"] }
-git2 = "0.19.0"
-git2-curl = "0.20.0"
+git2 = "0.20.0"
+git2-curl = "0.21.0"
 gix = { version = "0.64.0", default-features = false, features = ["blocking-http-transport-curl", "progress-tree", "parallel", "dirwalk"] }
 glob = "0.3.1"
 handlebars = { version = "5.1.2", features = ["dir_source"] }
@@ -63,7 +63,7 @@ itertools = "0.13.0"
 jobserver = "0.1.32"
 lazycell = "1.3.0"
 libc = "0.2.155"
-libgit2-sys = "0.17.0"
+libgit2-sys = "0.18.0"
 libloading = "0.8.5"
 memchr = "2.7.4"
 miow = "0.6.0"
