class Rust < Formula
  desc "Safe, concurrent, practical language"
  homepage "https://www.rust-lang.org/"
  license any_of: ["Apache-2.0", "MIT"]

  stable do
    url "https://static.rust-lang.org/dist/rustc-1.77.0-src.tar.gz"
    sha256 "0d6ccd1fa845fe3456b9ed4d483fc06acf9bbae9417e396b5144488c1a522d87"

    # From https://github.com/rust-lang/rust/tree/#{version}/src/tools
    resource "cargo" do
      url "https://github.com/rust-lang/cargo/archive/refs/tags/0.78.0.tar.gz"
      sha256 "9adbcd40704720174f529168cff26d3b6f74d85c152a6a0c32a16e774f7672b3"
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "daeab0c244dcfb2c9bceac0f9db6a3517a6b4a06804de0a37935bcd359b07468"
    sha256 cellar: :any,                 arm64_ventura:  "077d470ff1aaa029d544cd98704c0e609f3b414f7145e64b9331d1cd0f546690"
    sha256 cellar: :any,                 arm64_monterey: "4ae5ace7a17b60e20f39eb118096959d9a71ae6b388e1abe495608601e7127a5"
    sha256 cellar: :any,                 sonoma:         "1de1aada2510c88922984909316f75e1ab5a47babcfd3cdc59d7aa74f23dab6b"
    sha256 cellar: :any,                 ventura:        "d611242154cf14c66bf8b7c07fe99d7ad63461f428c516d0c3ad612c5d954567"
    sha256 cellar: :any,                 monterey:       "0327b0f7d6537b0c5a0e35730bf02069fd06d9202167b831141a047276091dc7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7a374dcb5adc588582a067abd93af3c08e3b153cccf376753bce542b5efe6c85"
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
  depends_on "pkg-config"

  uses_from_macos "python" => :build
  uses_from_macos "curl"
  uses_from_macos "zlib"

  # From https://github.com/rust-lang/rust/blob/#{version}/src/stage0.json
  resource "cargobootstrap" do
    on_macos do
      on_arm do
        url "https://static.rust-lang.org/dist/2024-02-08/cargo-1.76.0-aarch64-apple-darwin.tar.xz"
        sha256 "c963d3bf8f07077b0c87922e53ebb8999c601848def13d6f60a7a102dfa2a8a5"
      end
      on_intel do
        url "https://static.rust-lang.org/dist/2024-02-08/cargo-1.76.0-x86_64-apple-darwin.tar.xz"
        sha256 "c69b9e1167d8c67e46b6c933417af09fd8e26e2ee14c04aadad097977b3cd6a3"
      end
    end

    on_linux do
      on_arm do
        url "https://static.rust-lang.org/dist/2024-02-08/cargo-1.76.0-aarch64-unknown-linux-gnu.tar.xz"
        sha256 "d0c54d824e64b7313a974409541ca3a157b3ed7299865786bd0c440b0e073091"
      end
      on_intel do
        url "https://static.rust-lang.org/dist/2024-02-08/cargo-1.76.0-x86_64-unknown-linux-gnu.tar.xz"
        sha256 "30ec0ad9fca443ec12c544f9ce448dacdde411a45b9042961938b650e918ccfb"
      end
    end
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

    resource("cargobootstrap").stage do
      system "./install.sh", "--prefix=#{buildpath}/cargobootstrap"
    end
    ENV.prepend_path "PATH", buildpath/"cargobootstrap/bin"

    cargo_src_path = buildpath/"src/tools/cargo"
    cargo_src_path.rmtree
    resource("cargo").stage cargo_src_path
    if OS.mac?
      inreplace cargo_src_path/"Cargo.toml",
                /^curl\s*=\s*"(.+)"$/,
                'curl = { version = "\\1", features = ["force-system-lib-on-osx"] }'
    end

    # rustfmt and rust-analyzer are available in their own formulae.
    tools = %w[
      analysis
      cargo
      clippy
      rustdoc
      rust-analyzer-proc-macro-srv
      rust-demangler
      src
    ]
    args = %W[
      --prefix=#{prefix}
      --sysconfdir=#{etc}
      --tools=#{tools.join(",")}
      --llvm-root=#{Formula["llvm"].opt_prefix}
      --enable-llvm-link-shared
      --enable-vendor
      --disable-cargo-native-static
      --enable-profiler
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

    (lib/"rustlib/src/rust").install "library"
    rm_f [
      bin.glob("*.old"),
      lib/"rustlib/install.log",
      lib/"rustlib/uninstall.sh",
      (lib/"rustlib").glob("manifest-*"),
    ]
  end

  def post_install
    Dir["#{lib}/rustlib/**/*.dylib"].each do |dylib|
      chmod 0664, dylib
      MachO::Tools.change_dylib_id(dylib, "@rpath/#{File.basename(dylib)}")
      MachO.codesign!(dylib) if Hardware::CPU.arm?
      chmod 0444, dylib
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
    (testpath/"hello.rs").write <<~EOS
      fn main() {
        println!("Hello World!");
      }
    EOS
    system bin/"rustc", "hello.rs"
    assert_equal "Hello World!\n", shell_output("./hello")
    system bin/"cargo", "new", "hello_world", "--bin"
    assert_equal "Hello, world!", cd("hello_world") { shell_output("#{bin}/cargo run").split("\n").last }

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
