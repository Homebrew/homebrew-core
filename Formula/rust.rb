class Rust < Formula
  desc "Safe, concurrent, practical language"
  homepage "https://www.rust-lang.org/"

  stable do
    url "https://static.rust-lang.org/dist/rustc-1.10.0-src.tar.gz"
    sha256 "a4015aacf4f6d8a8239253c4da46e7abaa8584f8214d1828d2ff0a8f56176869"

    resource "cargo" do
      # git required because of submodules
      url "https://github.com/rust-lang/cargo.git", :tag => "0.11.0", :revision => "259324cd8f9bb6e1068a3a2b77685e90fda3e3b6"
    end

    # name includes date to satisfy cache
    resource "cargo-nightly-2015-09-17" do
      url "https://static-rust-lang-org.s3.amazonaws.com/cargo-dist/2015-09-17/cargo-nightly-x86_64-apple-darwin.tar.gz"
      sha256 "02ba744f8d29bad84c5e698c0f316f9e428962b974877f7f582cd198fdd807a8"
    end
  end

  bottle do
    sha256 "b6fc2ebfed237d15269118a52810a3660c7d50a8097c6c48044e95a2fb9ead24" => :el_capitan
    sha256 "4200756cc985257f888a02a02032588108649e4aae84e7340239b5be77a7730c" => :yosemite
    sha256 "816521dfa0f3f10cf50a2894dcf3aeceb6edb86ec29c7733a234d834e15287e7" => :mavericks
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
