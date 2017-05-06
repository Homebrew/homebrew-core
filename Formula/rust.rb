class Rust < Formula
  desc "Safe, concurrent, practical language"
  homepage "https://www.rust-lang.org/"

  stable do
    url "https://static.rust-lang.org/dist/rustc-1.17.0-src.tar.gz"
    sha256 "4baba3895b75f2492df6ce5a28a916307ecd1c088dc1fd02dbfa8a8e86174f87"

    resource "cargo" do
      url "https://github.com/rust-lang/cargo.git",
          :tag => "0.18.0",
          :revision => "fe7b0cdcf5ca7aab81630706ce40b70f6aa2e666"
    end

    resource "racer" do
      url "https://github.com/phildawes/racer/archive/2.0.6.tar.gz"
      sha256 "a9704478f72037e76d4d3702fe39b3c50597bde35dac1a11bf8034de87bbdc70"
    end

    # Currently rust stable won't build on Sierra according to our
    # knowledge. Before we update to a version that works or otherwise patch
    # the current version, let's disable it on Sierra to stop folks from
    # wasting hours and hours trying to build it.
    depends_on MaximumMacOSRequirement => :el_capitan
  end

  bottle do
    sha256 "da39e9680d86e78cfcd4e77befe28d637860f7fea6851f7f692095ba3f783576" => :sierra
    sha256 "6a634a36568b187c5245373ea1401a890b331a414f50086620d0a8f19c4a9e83" => :el_capitan
    sha256 "f540a366cc7bbcee1c8a6be804a0832541abaa9c076de189ee8c832e86545031" => :yosemite
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
    url "https://s3.amazonaws.com/rust-lang-ci/cargo-builds/6b05583d71f982bcad049b9fa094c637c062e751/cargo-nightly-x86_64-apple-darwin.tar.gz"
    # From name=cargo-nightly-x86_64-apple-darwin; tar -xf $name.tar.gz $name/version; cat $name/version
    version "2017-03-13"
    sha256 "0ed926ec3e5299f27fcc65f565572d2ee62fb79fc1707acfe81ced84981a30c6"
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
