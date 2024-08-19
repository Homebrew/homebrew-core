class Rust < Formula
  desc "Safe, concurrent, practical language"
  homepage "https://www.rust-lang.org/"
  license any_of: ["Apache-2.0", "MIT"]

  stable do
    url "https://static.rust-lang.org/dist/rustc-1.80.1-src.tar.gz"
    sha256 "2c0b8f643942dcb810cbcc50f292564b1b6e44db5d5f45091153996df95d2dc4"

    # From https://github.com/rust-lang/rust/tree/#{version}/src/tools
    resource "cargo" do
      url "https://github.com/rust-lang/cargo/archive/refs/tags/0.81.0.tar.gz"
      sha256 "5d2ea954f1a8bf03389fe2cefc5603de180a0c0010aa66628a325007216ef862"
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "96fc16c5b23a1ebf08f74357dfa11e84578b1c6884b54b16f23162530e93b2fb"
    sha256 cellar: :any,                 arm64_ventura:  "22a7875c137cd68a01c09d6b8f2bb9ceb5dd56b3f388d68ecbe06450664fe57e"
    sha256 cellar: :any,                 arm64_monterey: "81ad407748a18551299dc0f7e4373dc26b11a3933abf5f386d2087be2577625a"
    sha256 cellar: :any,                 sonoma:         "78e8c7f74d9773b1c5bf79fd4b7f5aabf2ac037ea6507f7431b0a6cc7cc53ace"
    sha256 cellar: :any,                 ventura:        "6903fc2b63bfa7a24b5e0cf0edb0e435a20e708409f11b50172c76009df05877"
    sha256 cellar: :any,                 monterey:       "cdb924e4d733710a4068c9ddbf9693777e0be9719e40c71fae39a74f0112f018"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e3678845ef50ee19dfb9898d762d73e3bd48e6c88cb4ad6de94ee86c51d23c52"
  end

  head do
    url "https://github.com/rust-lang/rust.git", branch: "master"

    resource "cargo" do
      url "https://github.com/rust-lang/cargo.git", branch: "master"
    end
  end

  depends_on "libgit2@1.7"
  depends_on "libssh2"
  depends_on "llvm"
  depends_on macos: :sierra
  depends_on "openssl@3"
  depends_on "pkg-config"

  uses_from_macos "python" => :build
  uses_from_macos "curl"
  uses_from_macos "zlib"

  # From https://github.com/rust-lang/rust/blob/#{version}/src/stage0
  resource "cargobootstrap" do
    on_macos do
      on_arm do
        url "https://static.rust-lang.org/dist/2024-06-13/cargo-1.79.0-aarch64-apple-darwin.tar.xz"
        sha256 "2cc674f17c18b0c01e0e5a8e5caedc26b0f499d2cc10605cf1a838e2cad9ef7d"
      end
      on_intel do
        url "https://static.rust-lang.org/dist/2024-06-13/cargo-1.79.0-x86_64-apple-darwin.tar.xz"
        sha256 "e1326c13b7437a72e061a2d662400c114ef87b73c45ef8823ea1b2bdc3140109"
      end
    end

    on_linux do
      on_arm do
        url "https://static.rust-lang.org/dist/2024-06-13/cargo-1.79.0-aarch64-unknown-linux-gnu.tar.xz"
        sha256 "4ca5e9bd141b0111387ea1aa0355f87eb8d0da52fbc616cefa4ecde4997aa65b"
      end
      on_intel do
        url "https://static.rust-lang.org/dist/2024-06-13/cargo-1.79.0-x86_64-unknown-linux-gnu.tar.xz"
        sha256 "07fcadd27b645ad58ff4dae5ef166fd730311bbae8f25f6640fe1bfd2a1f3c3c"
      end
    end
  end

  def install
    # relates to https://github.com/rust-lang/rust/pull/126507
    odie "bump to use libgit2 1.8" if version >= "1.81.0"

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
    rm_r(cargo_src_path)
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
      --enable-profiler
      --enable-vendor
      --disable-cargo-native-static
      --disable-docs
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
    rm([
      bin.glob("*.old"),
      lib/"rustlib/install.log",
      lib/"rustlib/uninstall.sh",
      (lib/"rustlib").glob("manifest-*"),
    ])
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
        Formula["libgit2@1.7"].opt_lib/shared_library("libgit2"),
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
