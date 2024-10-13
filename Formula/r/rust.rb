class Rust < Formula
  desc "Safe, concurrent, practical language"
  homepage "https://www.rust-lang.org/"
  license any_of: ["Apache-2.0", "MIT"]
  revision 1

  stable do
    url "https://static.rust-lang.org/dist/rustc-1.81.0-src.tar.gz"
    sha256 "872448febdff32e50c3c90a7e15f9bb2db131d13c588fe9071b0ed88837ccfa7"

    # From https://github.com/rust-lang/rust/tree/#{version}/src/tools
    resource "cargo" do
      url "https://github.com/rust-lang/cargo/archive/refs/tags/0.82.0.tar.gz"
      sha256 "1c89e6a7a28dd78aca53227fd5e14340fcb7cb154ad9655a2f304b5687986cc3"
    end
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "5ac9af77ca0af21928aea2c4ff945b4c2641cf3cd6fe5a05f900407c022b67b5"
    sha256 cellar: :any,                 arm64_sonoma:  "ee7e4b14245fdc2cc0eb624e32dd19cd90c68a13fd0ce8880dc9d227f26a0250"
    sha256 cellar: :any,                 arm64_ventura: "7c44e804a2d41c2367420779c3abe4b07bfdd369372d92115f63d5d41a25b52b"
    sha256 cellar: :any,                 sonoma:        "61ca738cfd88cd304a4983148a74e6e06cc076842b1bb8625e8b7022362249f2"
    sha256 cellar: :any,                 ventura:       "764f9261722fb7759009d0a2a294d191eda51facae1be7721f3e028856fe9f13"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c9226705d4c61a4fd96a004db47492db39a71e78cc34c8b1eb6c02aef25e22a1"
  end

  head do
    url "https://github.com/rust-lang/rust.git", branch: "master"

    resource "cargo" do
      url "https://github.com/rust-lang/cargo.git", branch: "master"
    end
  end

  depends_on "libgit2"
  depends_on "libssh2"
  depends_on "llvm@18"
  depends_on macos: :sierra
  depends_on "openssl@3"
  depends_on "pkg-config"
  depends_on "zstd"

  uses_from_macos "python" => :build
  uses_from_macos "curl"
  uses_from_macos "zlib"

  link_overwrite "etc/bash_completion.d/cargo"
  # These used to belong in `rustfmt`.
  link_overwrite "bin/cargo-fmt", "bin/git-rustfmt", "bin/rustfmt", "bin/rustfmt-*"

  # From https://github.com/rust-lang/rust/blob/#{version}/src/stage0
  resource "cargobootstrap" do
    on_macos do
      on_arm do
        url "https://static.rust-lang.org/dist/2024-08-08/rustc-1.80.1-aarch64-apple-darwin.tar.xz"
        sha256 "b22ac69b19de26fed67634379ae72cbc8fcc2ad1b1d97c4fbcb747264e69f13c"
      end
      on_intel do
        url "https://static.rust-lang.org/dist/2024-08-08/rustc-1.80.1-x86_64-apple-darwin.tar.xz"
        sha256 "72f7a04d1d283a24d76f1fe2317f7ec97daaeeb4010907ca5e7ef83790d94469"
      end
    end

    on_linux do
      on_arm do
        url "https://static.rust-lang.org/dist/2024-08-08/rustc-1.80.1-aarch64-unknown-linux-gnu.tar.xz"
        sha256 "fc21ca734504c3d0ccaf361f05cb491142c365ce8a326f942206b0199c49bbb4"
      end
      on_intel do
        url "https://static.rust-lang.org/dist/2024-08-08/rustc-1.80.1-x86_64-unknown-linux-gnu.tar.xz"
        sha256 "0367f069b49560af5c61810530d4721ad13eecfcb48952e67a2c32be903d5043"
      end
    end
  end

  def llvm
    Formula["llvm@18"]
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
    rm_r(cargo_src_path)
    resource("cargo").stage cargo_src_path
    if OS.mac?
      inreplace cargo_src_path/"Cargo.toml",
                /^curl\s*=\s*"(.+)"$/,
                'curl = { version = "\\1", features = ["force-system-lib-on-osx"] }'
    end

    # rust-analyzer is available in its own formula.
    tools = %w[
      analysis
      cargo
      clippy
      rustdoc
      rustfmt
      rust-analyzer-proc-macro-srv
      rust-demangler
      src
    ]
    args = %W[
      --prefix=#{prefix}
      --sysconfdir=#{etc}
      --tools=#{tools.join(",")}
      --llvm-root=#{llvm.opt_prefix}
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

    bash_completion.install etc/"bash_completion.d/cargo"
    (lib/"rustlib/src/rust").install "library"
    rm([
      bin.glob("*.old"),
      lib/"rustlib/install.log",
      lib/"rustlib/uninstall.sh",
      (lib/"rustlib").glob("manifest-*"),
    ])
  end

  def post_install
    lib.glob("rustlib/**/*.dylib") do |dylib|
      chmod 0664, dylib
      MachO::Tools.change_dylib_id(dylib, "@rpath/#{File.basename(dylib)}")
      MachO.codesign!(dylib) if Hardware::CPU.arm?
      chmod 0444, dylib
    end
    return unless OS.mac?

    # Symlink our LLVM here to make sure the adjacent bin/rust-lld can find it.
    # Needs to be done in `postinstall` to avoid having `change_dylib_id` done on it.
    lib.glob("rustlib/*/lib") do |dir|
      # Use `ln_sf` instead of `install_symlink` to avoid resolving this into a Cellar path.
      ln_sf llvm.opt_lib/shared_library("libLLVM"), dir
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

    assert_match <<~EOS, shell_output("#{bin}/rustfmt --check hello.rs", 1)
       fn main() {
      -  println!("Hello World!");
      +    println!("Hello World!");
       }
    EOS

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
