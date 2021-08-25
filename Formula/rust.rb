class Rust < Formula
  desc "Safe, concurrent, practical language"
  homepage "https://www.rust-lang.org/"
  license any_of: ["Apache-2.0", "MIT"]
  revision 1

  stable do
    url "https://static.rust-lang.org/dist/rustc-1.54.0-src.tar.gz"
    sha256 "ac8511633e9b5a65ad030a1a2e5bdaa841fdfe3132f2baaa52cc04e71c6c6976"

    # From https://github.com/rust-lang/rust/tree/#{version}/src/tools
    resource "cargo" do
      url "https://github.com/rust-lang/cargo.git",
          tag:      "0.55.0",
          revision: "5ae8d74b3b2d58f32c8d357e5cfa04d430a70e0b"

      # Work around crates.io timeouts with newer curl versions
      # https://github.com/rust-lang/cargo/pull/9695
      patch do
        url "https://github.com/rust-lang/cargo/commit/27277d966b3cfa454d6dea7f724cb961c036251c.patch?full_index=1"
        sha256 "55bf95b62dd38f372747922e5530544321601cf4c0e87e8174f440aa874f522d"
      end
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "63c7e4b6ed3d5262fbc67a4850234624f5139d2d71261917eceadb7681589a6a"
    sha256 cellar: :any,                 big_sur:       "8e324bb50e3176b3287aeac558deb3bb62631fcf49f56ab656761d7406669b63"
    sha256 cellar: :any,                 catalina:      "802d25a7e561ab9aee2e9496f511e17bc231eb6f0a6a41dbf8c4f770fef3537d"
    sha256 cellar: :any,                 mojave:        "5589f6ecdfc6f0401dcc899ee4a2664b499d884e1e4a64cbd68d7e09c392df6a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "900fd9e2f3c90a2a8524225e5524a71c0f91c1dd2cab08b07285dce24d998a31"
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
      # From https://github.com/rust-lang/rust/blob/#{version}/src/stage0.txt
      if Hardware::CPU.arm?
        url "https://static.rust-lang.org/dist/2021-06-17/cargo-1.53.0-aarch64-apple-darwin.tar.gz"
        sha256 "5f0aea0cd507ff6e3b1e1ae54a8726172d055a8b6d8b1ba550ce9ebc96a8a891"
      else
        url "https://static.rust-lang.org/dist/2021-06-17/cargo-1.53.0-x86_64-apple-darwin.tar.gz"
        sha256 "b42f4a7d054e219d8744af48cfab798473981455a050a320c46b164382726e50"
      end
    end

    on_linux do
      # From: https://github.com/rust-lang/rust/blob/#{version}/src/stage0.txt
      url "https://static.rust-lang.org/dist/2021-06-17/cargo-1.53.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "e79d9d0b03cb331428ef3cfc4cbe60ded9f90708a7dd1714d974dab9a03ee7b3"
    end
  end

  def install
    ENV.prepend_path "PATH", Formula["python@3.9"].opt_libexec/"bin"

    # Fix build failure for compiler_builtins "error: invalid deployment target
    # for -stdlib=libc++ (requires OS X 10.7 or later)"
    on_macos { ENV["MACOSX_DEPLOYMENT_TARGET"] = MacOS.version }

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
      on_macos do
        args += %w[--features curl-sys/force-system-lib-on-osx]
      end
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
