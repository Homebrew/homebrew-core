class Rust < Formula
  desc "Safe, concurrent, practical language"
  homepage "https://www.rust-lang.org/"
  license any_of: ["Apache-2.0", "MIT"]

  stable do
    url "https://static.rust-lang.org/dist/rustc-1.59.0-src.tar.gz"
    sha256 "a7c8eeaee85bfcef84c96b02b3171d1e6540d15179ff83dddd9eafba185f85f9"

    # From https://github.com/rust-lang/rust/tree/#{version}/src/tools
    resource "cargo" do
      url "https://github.com/rust-lang/cargo.git",
          tag:      "0.60.0",
          revision: "49d8809dc2d3e6e0d5ec634fcf26d8e2aab67130"
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "b5654c7867cd277e4834a6e313c519efe4296a0a6883cb0a876e1c89d2b3755a"
    sha256 cellar: :any,                 arm64_big_sur:  "6c7c2f297e7e0dcdbeba542168db942bb524885a2e51221891ad69a53988b36f"
    sha256 cellar: :any,                 monterey:       "04abe4382d060f10d838cb51ab3161d1604c6eafe1c599d4853c2414a92fe675"
    sha256 cellar: :any,                 big_sur:        "bd4de413f945477bb9f976e747201987545c4940d286418594c1c5f912ecfcea"
    sha256 cellar: :any,                 catalina:       "e62ad24822a95bc4d5c10c02d2f4b49ee39abc100d04f1b977abfd927b3d3fd2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4fdc8c022fc3d2429be936163e5e760b4af5c084635246560126f8296e8653db"
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
        url "https://static.rust-lang.org/dist/2022-01-13/cargo-1.58.0-aarch64-apple-darwin.tar.gz"
        sha256 "9144ee0f614c8dcb5f34a774e47a24b676860fa442afda2a3c7f45abfe694e6a"
      else
        url "https://static.rust-lang.org/dist/2022-01-13/cargo-1.58.0-x86_64-apple-darwin.tar.gz"
        sha256 "60203fc7ec453f2a9eb93734c70a72f8ee88e349905edded04155c1646e283a6"
      end
    end

    on_linux do
      # From: https://github.com/rust-lang/rust/blob/#{version}/src/stage0.json
      url "https://static.rust-lang.org/dist/2022-01-13/cargo-1.58.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "940aa91ad2de39c18749e8d789d88846de2debbcf6207247225b42c6c3bf731a"
    end
  end

  def install
    ENV.prepend_path "PATH", Formula["python@3.9"].opt_libexec/"bin"

    # Ensure that the `openssl` crate picks up the intended library.
    # https://crates.io/crates/openssl#manual-configuration
    ENV["OPENSSL_DIR"] = Formula["openssl@1.1"].opt_prefix

    args = ["--prefix=#{prefix}", "--enable-vendor"]
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
    assert_equal "Hello World!\n", `./hello`
    system bin/"cargo", "new", "hello_world", "--bin"
    assert_equal "Hello, world!", cd("hello_world") { shell_output("#{bin}/cargo run").split("\n").last }
  end
end
