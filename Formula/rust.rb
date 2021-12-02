class Rust < Formula
  desc "Safe, concurrent, practical language"
  homepage "https://www.rust-lang.org/"
  license any_of: ["Apache-2.0", "MIT"]

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
    sha256 cellar: :any,                 arm64_monterey: "58189da7cb381f3ca4600ac6ce22280faa913befe1c4772b2cb546310b8cf6ee"
    sha256 cellar: :any,                 arm64_big_sur:  "4ef461b5e0ce1ef9f83308fca7a5da406bdeccee7c8fa19fb9277ebcd75efafb"
    sha256 cellar: :any,                 monterey:       "18fbf3c9385b2f36384fa14643c723f73fbfa49aeac5fc2cc420dd7ccb712561"
    sha256 cellar: :any,                 big_sur:        "20624f172ed0275e7360facdd5fe0267317d4edfa0fc099264673648ab5cdee6"
    sha256 cellar: :any,                 catalina:       "7eb748e8f01e64656b23083f20a2887a344a200d28e1cbec6d95407b321f160f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cba480896934378891fdb66d4749470b515c99d773b816be690e7b46d8f3d6bb"
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

  # Make sure object files in static archives have distinct names.
  # https://github.com/rust-lang/compiler-builtins/issues/443
  patch do
    url "https://github.com/rust-lang/compiler-builtins/commit/eaab9d29ecbf538369d7f26953425eb78dae8229.patch?full_index=1"
    sha256 "2eaafddf3dad416431b42f3a5e222a2d4261ab026a165c7f23d6ec378a0ccff5"
    directory "vendor/compiler_builtins"
  end

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
