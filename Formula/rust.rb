class Rust < Formula
  desc "Safe, concurrent, practical language"
  homepage "https://www.rust-lang.org/"
  license any_of: ["Apache-2.0", "MIT"]

  stable do
    url "https://static.rust-lang.org/dist/rustc-1.56.0-src.tar.gz"
    sha256 "cd0fd72d698deb3001c18e0f4bf8261d8f86420097eef94ca3a1fe047f2df43f"

    # From https://github.com/rust-lang/rust/tree/#{version}/src/tools
    resource "cargo" do
      url "https://github.com/rust-lang/cargo.git",
          tag:      "0.57.0",
          revision: "4ed5d137baff5eccf1bae5a7b2ae4b57efad4a7d"
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "40e175d1bf768e358aa3b8336fef271c9a64f5c2078584a2dbdfa21a3b0fc3e5"
    sha256 cellar: :any,                 arm64_big_sur:  "5fbc40e3c283504097bccdb42d8f415ebab75e0382c29918ffc3759ffb38862a"
    sha256 cellar: :any,                 monterey:       "85e557ed9bb6c6abb6911f5f94e20798578a8a02fc1d78f613d7e31348cd43a4"
    sha256 cellar: :any,                 big_sur:        "40a3705fcbacfd5260d0cda543008ba7c2ec291ea61d74bb1a3643e8baaff02f"
    sha256 cellar: :any,                 catalina:       "cc59d78cc7392a75c8cd81388c68bb26fe7a178660b7632194765402670769a4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fbdb014a75b4be922a9f5b51e387e5f8a0800533f7c72be6db7c2bc6c0a87765"
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
        url "https://static.rust-lang.org/dist/2021-09-09/cargo-1.55.0-aarch64-apple-darwin.tar.gz"
        sha256 "9e49c057f8020fa4f67e6530aa2929c175e5417d19fc9f3a14c9ffb168c2932d"
      else
        url "https://static.rust-lang.org/dist/2021-09-09/cargo-1.55.0-x86_64-apple-darwin.tar.gz"
        sha256 "4e004cb231c8efbd4241b012c6abeefc7d61e2b4357cfe69feb0d4a448d30f05"
      end
    end

    on_linux do
      # From: https://github.com/rust-lang/rust/blob/#{version}/src/stage0.txt
      url "https://static.rust-lang.org/dist/2021-09-09/cargo-1.55.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "bb18c74aea07fa29c7169ce78756dfd08c07da08c584874e09fa6929c8267ec1"
    end
  end

  def install
    ENV.prepend_path "PATH", Formula["python@3.9"].opt_libexec/"bin"

    # Fix build failure for compiler_builtins "error: invalid deployment target
    # for -stdlib=libc++ (requires OS X 10.7 or later)"
    ENV["MACOSX_DEPLOYMENT_TARGET"] = MacOS.version if OS.mac?

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
