class Rust < Formula
  desc "Safe, concurrent, practical language"
  homepage "https://www.rust-lang.org/"

  stable do
    url "https://static.rust-lang.org/dist/rustc-1.13.0-src.tar.gz"
    sha256 "ecb84775ca977a5efec14d0cad19621a155bfcbbf46e8050d18721bb1e3e5084"

    resource "cargo" do
      # git required because of submodules
      url "https://github.com/rust-lang/cargo.git", :tag => "0.13.0", :revision => "109cb7c33d426044d141457049bd0fffaca1327c"
    end

    # name includes date to satisfy cache
    resource "cargo-nightly-2015-09-17" do
      url "https://static-rust-lang-org.s3.amazonaws.com/cargo-dist/2015-09-17/cargo-nightly-x86_64-apple-darwin.tar.gz"
      sha256 "02ba744f8d29bad84c5e698c0f316f9e428962b974877f7f582cd198fdd807a8"
    end
  end

  bottle do
    sha256 "111e44bb02839030396f3dc991e6a9c1b3ae9c7f8b6d7511ac652a629ac521e9" => :sierra
    sha256 "6dca92f516a4b050838fe30fd4001721e20d5714d45e19a52d35f279314e416d" => :el_capitan
    sha256 "f8ee576f5002b7b15f4e62ef9ffc95e9102ef742cd6240cc85dae783ddc0e362" => :yosemite
  end

  head do
    url "https://github.com/rust-lang/rust.git"
    resource "cargo" do
      url "https://github.com/rust-lang/cargo.git"
    end
  end

  option "with-llvm", "Build with brewed LLVM. By default, Rust's LLVM will be used."

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

    resource("cargo").stage do
      cargo_stage_path = pwd

      if build.stable?
        resource("cargo-nightly-2015-09-17").stage do
          system "./install.sh", "--prefix=#{cargo_stage_path}/target/snapshot/cargo"
          # satisfy make target to skip download
          touch "#{cargo_stage_path}/target/snapshot/cargo/bin/cargo"
        end
      end

      system "./configure", "--prefix=#{prefix}", "--local-rust-root=#{prefix}", "--enable-optimize"
      system "make"
      system "make", "install"
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
