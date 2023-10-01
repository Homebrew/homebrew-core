class Rust < Formula
  desc "Safe, concurrent, practical language"
  homepage "https://www.rust-lang.org/"
  license any_of: ["Apache-2.0", "MIT"]

  stable do
    # TODO: try switching to `llvm` 17 at 1.73.0.
    # See: https://github.com/rust-lang/rust/issues/116020
    url "https://static.rust-lang.org/dist/rustc-1.72.1-src.tar.gz"
    sha256 "7f48845f6a52cdbb5d63fb0528fd5f520eb443275b55f98e328159f86568f895"

    # From https://github.com/rust-lang/rust/tree/#{version}/src/tools
    # When bumping to a new version, check if we can use unversioned `libgit2`.
    # See comments below for details.
    resource "cargo" do
      url "https://github.com/rust-lang/cargo/archive/refs/tags/0.73.1.tar.gz"
      sha256 "976fb6f3e773319e60875772478645297d9eacc852857e288e8cec65399d2c88"
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "40687edb42b50bdf778643803a21a98fca07d86b6a138edfdd73a282c1e18ad8"
    sha256 cellar: :any,                 arm64_ventura:  "be9922a4b56016f18d209067f5a4d148d2aad4db3061092f848744aff41e337d"
    sha256 cellar: :any,                 arm64_monterey: "a9ada0e355a336a55545a16e615daa051c5a675dc05c63793a77b8bac98ba04e"
    sha256 cellar: :any,                 arm64_big_sur:  "9bfc9baf003134053944ad145cc48155a23607ff73fecd6d45d1e4d3b429d6fd"
    sha256 cellar: :any,                 sonoma:         "fbc3c8c3894f64dc121541cc9a50fb22a38ccff82d4dba9c370d70a6785f614e"
    sha256 cellar: :any,                 ventura:        "4cd3be4492eae97232dd1d868fb40f849882724688c4bd792f1e720d8710803d"
    sha256 cellar: :any,                 monterey:       "f7b8d6dc15d845f4ad715706542237386f97cf045e9168b34876bccb060e0e26"
    sha256 cellar: :any,                 big_sur:        "20214e26fbc77ef51e3be59c970ed9a109f3c13cfa7331a973d60d06b907760a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "36b6bb23066fccd7b3c9311d5c671768133bbe5c27cce132376c4c0ec30abf9c"
  end

  head do
    url "https://github.com/rust-lang/rust.git", branch: "master"

    resource "cargo" do
      url "https://github.com/rust-lang/cargo.git", branch: "master"
    end
  end

  # To check for `libgit2` version:
  # 1. Search for `libgit2-sys` version at https://github.com/rust-lang/cargo/blob/#{cargo_version}/Cargo.lock
  # 2. If the version suffix of `libgit2-sys` is newer than +1.6.*, then:
  #    - Use the corresponding `libgit2` formula.
  #    - Change the `LIBGIT2_SYS_USE_PKG_CONFIG` env var below to `LIBGIT2_NO_VENDOR`.
  #      See: https://github.com/rust-lang/git2-rs/commit/59a81cac9ada22b5ea6ca2841f5bd1229f1dd659.
  depends_on "libgit2@1.6"
  depends_on "libssh2"
  depends_on "llvm@16"
  depends_on "openssl@3"
  depends_on "pkg-config"

  uses_from_macos "python" => :build
  uses_from_macos "curl"
  uses_from_macos "zlib"

  # From https://github.com/rust-lang/rust/blob/#{version}/src/stage0.json
  resource "cargobootstrap" do
    on_macos do
      on_arm do
        url "https://static.rust-lang.org/dist/2023-07-13/cargo-1.71.0-aarch64-apple-darwin.tar.xz"
        sha256 "7637bc54d15cec656d7abb32417316546c7a784eded8677753b5dad7f05b5b09"
      end
      on_intel do
        url "https://static.rust-lang.org/dist/2023-07-13/cargo-1.71.0-x86_64-apple-darwin.tar.xz"
        sha256 "d83fe33cabf20394168f056ead44d243bd37dc96165d87867ea5114cfb52e739"
      end
    end

    on_linux do
      on_arm do
        url "https://static.rust-lang.org/dist/2023-07-13/cargo-1.71.0-aarch64-unknown-linux-gnu.tar.xz"
        sha256 "13e8ff23d6af976a45f3ab451bf698e318a8d1823d588ff8a989555096f894a8"
      end
      on_intel do
        url "https://static.rust-lang.org/dist/2023-07-13/cargo-1.71.0-x86_64-unknown-linux-gnu.tar.xz"
        sha256 "fe6fb520f59966300ee661d18b37c36cb3e614877c4c01dfedf987b8a9c577e9"
      end
    end
  end

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    # https://docs.rs/openssl/latest/openssl/#manual
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix

    ENV["LIBGIT2_SYS_USE_PKG_CONFIG"] = "1"
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
      rust-demangler
      src
    ]
    args = %W[
      --prefix=#{prefix}
      --sysconfdir=#{etc}
      --tools=#{tools.join(",")}
      --llvm-root=#{Formula["llvm@16"].opt_prefix}
      --enable-llvm-link-shared
      --enable-vendor
      --disable-cargo-native-static
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
        Formula["libgit2@1.6"].opt_lib/shared_library("libgit2"),
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
