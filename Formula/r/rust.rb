class Rust < Formula
  desc "Safe, concurrent, practical language"
  homepage "https://www.rust-lang.org/"
  license any_of: ["Apache-2.0", "MIT"]

  stable do
    url "https://static.rust-lang.org/dist/rustc-1.78.0-src.tar.gz"
    sha256 "ff544823a5cb27f2738128577f1e7e00ee8f4c83f2a348781ae4fc355e91d5a9"

    # From https://github.com/rust-lang/rust/tree/#{version}/src/tools
    resource "cargo" do
      url "https://github.com/rust-lang/cargo/archive/refs/tags/0.79.0.tar.gz"
      sha256 "b9de52bc7452fd74ab344b636f054de3e9a67cf167567cc4ce948e9219e81d98"
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "7d53d776e817dc07006a87ee524c2fa81678237d527a8a1447240d4299fbabc0"
    sha256 cellar: :any,                 arm64_ventura:  "1d40affdb3c24fd9c84aacc45b04099e7b30e96114e28e6bc305130cc3067a97"
    sha256 cellar: :any,                 arm64_monterey: "58a7e592076b94981fa9551caa9d9e698f02daf952c070d3611a31c2432cfd85"
    sha256 cellar: :any,                 sonoma:         "5217801123b3e52d8d0ceeb37f78208a184060b3c079f3b600bf7399408af3d2"
    sha256 cellar: :any,                 ventura:        "dc0ee2861b1c1429811257c237d7746393db220f10e701a29c4ac78600ec1a8f"
    sha256 cellar: :any,                 monterey:       "56a5a84d9b8573e6768a08e9de13a38c419b046e3fe8bd72ee1b11adc57cf61f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d73e76c6709d31530906725c69d67e7a3988c7ffd7635353e418d7b9dcddc14f"
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
        url "https://static.rust-lang.org/dist/2024-03-21/cargo-1.77.0-aarch64-apple-darwin.tar.xz"
        sha256 "30f0b45863da00856d29ff851a25dcaa73cc5a5e9ca2aa9e16529ab13777ba66"
      end
      on_intel do
        url "https://static.rust-lang.org/dist/2024-03-21/cargo-1.77.0-x86_64-apple-darwin.tar.xz"
        sha256 "c95b98a306b26bf5f4f43d4d212c4535f3a09bbeda569ea0431bc54824a267b4"
      end
    end

    on_linux do
      on_arm do
        url "https://static.rust-lang.org/dist/2024-03-21/cargo-1.77.0-aarch64-unknown-linux-gnu.tar.xz"
        sha256 "0833e133e2b98d840c5180a3dabc49c0de9895c54055dfee92fa94d2a12196d5"
      end
      on_intel do
        url "https://static.rust-lang.org/dist/2024-03-21/cargo-1.77.0-x86_64-unknown-linux-gnu.tar.xz"
        sha256 "0af971f126e0307d4e4d974f0e9c33fd1c2923274b14a0861823b5a019e8faf5"
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
