class Rust < Formula
  desc "Safe, concurrent, practical language"
  homepage "https://www.rust-lang.org/"

  stable do
    url "https://static.rust-lang.org/dist/rustc-1.14.0-src.tar.gz"
    sha256 "c790edd2e915bd01bea46122af2942108479a2fda9a6f76d1094add520ac3b6b"

    resource "cargo" do
      url "https://github.com/rust-lang/cargo.git",
          :tag => "0.15.0",
          :revision => "298a0127f703d4c2500bb06d309488b92ef84ae1"
    end

    resource "racer" do
      url "https://github.com/phildawes/racer/archive/2.0.4.tar.gz"
      sha256 "e30e383af4d01695e35d420e36c9b2cf462337f680497ae14c09388f14c53809"
    end
  end

  bottle do
    rebuild 1
    sha256 "0756b3e161683415ef0139b72ba2366f727f4e8b2be6040f0bd374fbf206365e" => :sierra
    sha256 "3932a3f79f35b74b917770ed2078d3ff2243b7730491b0f7e2b94a394884e2a3" => :el_capitan
    sha256 "c7d4222a23f16279c142f9778a6187bd5e15169caa04469085cb0fe6df865bdd" => :yosemite
  end

  head do
    url "https://github.com/rust-lang/rust.git"

    resource "cargo" do
      url "https://github.com/rust-lang/cargo.git"
    end
  end

  option "with-llvm", "Build with brewed LLVM. By default, Rust's LLVM will be used."
  option "with-racer", "Build Racer code completion tool, and retain Rust sources."

  depends_on "cmake" => :build
  depends_on "pkg-config" => :run
  depends_on "llvm" => :optional
  depends_on "openssl"
  depends_on "libssh2"

  conflicts_with "multirust", :because => "both install rustc, rustdoc, cargo, rust-lldb, rust-gdb"

  # According to the official readme, GCC 4.7+ is required
  fails_with :gcc_4_0
  fails_with :gcc
  ("4.3".."4.6").each do |n|
    fails_with :gcc => n
  end

  resource "cargobootstrap" do
    version "2016-11-02"
    url "https://static-rust-lang-org.s3.amazonaws.com/cargo-dist/2016-11-02/cargo-nightly-x86_64-apple-darwin.tar.gz"
    sha256 "3bfb2e3e7292a629b86b9fad1d7d6ea9531bb990964c02005305c5cea3a579d9"
  end

  def install
    args = ["--prefix=#{prefix}"]
    args << "--disable-rpath" if build.head?
    args << "--enable-clang" if ENV.compiler == :clang
    args << "--llvm-root=#{Formula["llvm"].opt_prefix}" if build.with? "llvm"
    if build.head?
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
      system "./configure", "--prefix=#{prefix}", "--local-rust-root=#{prefix}",
                            "--enable-optimize"
      system "make"
      system "make", "install"
    end

    if build.with? "racer"
      resource("racer").stage do
        ENV.prepend_path "PATH", bin
        cargo_home = buildpath/"cargo_home"
        cargo_home.mkpath
        ENV["CARGO_HOME"] = cargo_home
        system bin/"cargo", "build", "--release", "--verbose"
        (libexec/"bin").install "target/release/racer"
        (bin/"racer").write_env_script(libexec/"bin/racer", :RUST_SRC_PATH => pkgshare/"rust_src")
      end
      # Remove any binary files; as Homebrew will run ranlib on them and barf.
      rm_rf Dir["src/{llvm,test,librustdoc,etc/snapshot.pyc}"]
      (pkgshare/"rust_src").install Dir["src/*"]
    end

    rm_rf prefix/"lib/rustlib/uninstall.sh"
    rm_rf prefix/"lib/rustlib/install.log"
  end

  test do
    system "#{bin}/rustdoc", "-h"
    (testpath/"hello.rs").write <<-EOS.undent
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
