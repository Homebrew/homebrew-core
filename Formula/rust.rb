class Rust < Formula
  desc "Safe, concurrent, practical language"
  homepage "https://www.rust-lang.org/"
  revision 1

  stable do
    url "https://static.rust-lang.org/dist/rustc-1.18.0-src.tar.gz"
    sha256 "d2dc36e99b9e2269488b2bcddde43c234e6bde03edf70cba82a027ff49c36111"

    resource "cargo" do
      url "https://github.com/rust-lang/cargo.git",
          :tag => "0.19.0",
          :revision => "28d1d60d4b634b70d7ceb0808144f2337c83ab95"
    end

    resource "racer" do
      url "https://github.com/phildawes/racer/archive/2.0.8.tar.gz"
      sha256 "b6a1d3033fe5ca27674afceee936cf6d04b6fc11709513e230a039a2200f8797"
    end
  end

  bottle do
    sha256 "330dd281718d164d7415d83a6a8376cb2cc161ecee82e3fb6ba869a885b7fe8b" => :sierra
    sha256 "c90ae66966ab11382c50fc49c8ddb6320aa34390f3e76081a592e39a7e48a9fa" => :el_capitan
    sha256 "b0cfdaeb92b85192846d864f20fb6ca3a162163fb549918a223b4eef4eae3d91" => :yosemite
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

  conflicts_with "cargo-completion", :because => "both install shell completion for cargo"

  # According to the official readme, GCC 4.7+ is required
  fails_with :gcc_4_0
  fails_with :gcc
  ("4.3".."4.6").each do |n|
    fails_with :gcc => n
  end

  resource "cargobootstrap" do
    # From https://github.com/rust-lang/rust/blob/#{version}/src/stage0.txt
    url "https://static.rust-lang.org/dist/2017-04-27/cargo-0.18.0-x86_64-apple-darwin.tar.gz"
    sha256 "e5c69ed75f73cfcff0498a06da1017acaa190d912e0fe5e432b1439e4c0d4110"
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

  def post_install
    Dir["#{lib}/rustlib/**/*.dylib"].each do |dylib|
      chmod 0664, dylib
      MachO::Tools.change_dylib_id(dylib, "@rpath/#{File.basename(dylib)}")
      chmod 0444, dylib
    end
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
