class Rust < Formula
  desc "Safe, concurrent, practical language"
  homepage "https://www.rust-lang.org/"
  license any_of: ["Apache-2.0", "MIT"]

  stable do
    url "https://static.rust-lang.org/dist/rustc-1.94.0-src.tar.gz"
    sha256 "b83f921cd3f321ff614f9c06a8b870d89299fc02888b48a5549683a36823474c"

    # From https://github.com/rust-lang/rust/tree/#{version}/src/tools
    resource "cargo" do
      url "https://github.com/rust-lang/cargo/archive/refs/tags/0.95.0.tar.gz"
      sha256 "a646673df0564b6294d1810a33ca02a9e26c860c60c36769ca28bf58d6e73dcd"
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "6cc0c90642591826abb1c90fc90ef9c4f0ef4af9011478362a360fa8cb711de9"
    sha256 cellar: :any,                 arm64_sequoia: "1ec9051c282a5ac7cca94eeb10b6bc2095ed81b66a6f50239e58a54757bfc8a5"
    sha256 cellar: :any,                 arm64_sonoma:  "dc7acf3b2728cefe939dec012471e97b12df127f464aa888a7a90e99386c9fe3"
    sha256 cellar: :any,                 sonoma:        "0e1175aa104716ee4bf06481c72205db3c7a3c32954cdf3e70d3991c93473b2c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "37223e74a88b5c23ebc0a2202777506a325881feac112e36d457657090c646d6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9fc9c113b90b648c072467484182307d8a94ec7545d61935c256fc88c92c343e"
  end

  head do
    url "https://github.com/rust-lang/rust.git", branch: "main"

    resource "cargo" do
      url "https://github.com/rust-lang/cargo.git", branch: "master"
    end
  end

  depends_on "libgit2"
  depends_on "libssh2"
  depends_on "llvm@21"
  depends_on "openssl@3"
  depends_on "pkgconf"
  depends_on "zstd"

  uses_from_macos "python" => :build
  uses_from_macos "curl"

  # Required by Rust, see https://github.com/rust-lang/rust/issues/39870
  preserve_rpath

  link_overwrite "etc/bash_completion.d/cargo"
  # These used to belong in `rustfmt`.
  link_overwrite "bin/cargo-fmt", "bin/git-rustfmt", "bin/rustfmt", "bin/rustfmt-*"

  # From https://github.com/rust-lang/rust/blob/#{version}/src/stage0
  resource "rustc-bootstrap" do
    on_macos do
      on_arm do
        url "https://static.rust-lang.org/dist/2025-12-11/rustc-1.92.0-aarch64-apple-darwin.tar.xz", using: :nounzip
        sha256 "15dee753c9217dff4cf45d734b29dc13ce6017d8a55fe34eed75022b39a63ff0"
      end
      on_intel do
        url "https://static.rust-lang.org/dist/2025-12-11/rustc-1.92.0-x86_64-apple-darwin.tar.xz", using: :nounzip
        sha256 "0facbd5d2742c8e97c53d59c9b5b81db6088cfc285d9ecb99523a50d6765fc5c"
      end
    end

    on_linux do
      on_arm do
        url "https://static.rust-lang.org/dist/2025-12-11/rustc-1.92.0-aarch64-unknown-linux-gnu.tar.xz", using: :nounzip
        sha256 "7c8706fad4c038b5eacab0092e15db54d2b365d5f3323ca046fe987f814e7826"
      end
      on_intel do
        url "https://static.rust-lang.org/dist/2025-12-11/rustc-1.92.0-x86_64-unknown-linux-gnu.tar.xz", using: :nounzip
        sha256 "78b2dd9c6b1fcd2621fa81c611cf5e2d6950690775038b585c64f364422886e0"
      end
    end
  end

  # From https://github.com/rust-lang/rust/blob/#{version}/src/stage0
  resource "cargo-bootstrap" do
    on_macos do
      on_arm do
        url "https://static.rust-lang.org/dist/2025-12-11/cargo-1.92.0-aarch64-apple-darwin.tar.xz", using: :nounzip
        sha256 "bce6e7def37240c5a63115828017a9fc0ebcb31e64115382f5943b62b71aa34a"
      end
      on_intel do
        url "https://static.rust-lang.org/dist/2025-12-11/cargo-1.92.0-x86_64-apple-darwin.tar.xz", using: :nounzip
        sha256 "b033a7c33aba8af947c9d0ab2785f9696347cded228ffe731897f1c627466262"
      end
    end

    on_linux do
      on_arm do
        url "https://static.rust-lang.org/dist/2025-12-11/cargo-1.92.0-aarch64-unknown-linux-gnu.tar.xz", using: :nounzip
        sha256 "cb2ce6be6411b986e25c71ad8a813f9dfbe3461738136fd684e3644f8dd75df4"
      end
      on_intel do
        url "https://static.rust-lang.org/dist/2025-12-11/cargo-1.92.0-x86_64-unknown-linux-gnu.tar.xz", using: :nounzip
        sha256 "e5e12be2c7126a7036c8adf573078a28b92611f5767cc9bd0a6f7c83081df103"
      end
    end
  end

  # From https://github.com/rust-lang/rust/blob/#{version}/src/stage0
  resource "rust-std-bootstrap" do
    on_macos do
      on_arm do
        url "https://static.rust-lang.org/dist/2025-12-11/rust-std-1.92.0-aarch64-apple-darwin.tar.xz", using: :nounzip
        sha256 "ea619984fcb8e24b05dbd568d599b8e10d904435ab458dfba6469e03e0fd69aa"
      end
      on_intel do
        url "https://static.rust-lang.org/dist/2025-12-11/rust-std-1.92.0-x86_64-apple-darwin.tar.xz", using: :nounzip
        sha256 "6ce143bf9e83c71e200f4180e8774ab22c8c8c2351c88484b13ff13be82c8d57"
      end
    end

    on_linux do
      on_arm do
        url "https://static.rust-lang.org/dist/2025-12-11/rust-std-1.92.0-aarch64-unknown-linux-gnu.tar.xz", using: :nounzip
        sha256 "ce2ab42c09d633b0a8b4b65a297c700ae0fad47aae890f75894782f95be7e36d"
      end
      on_intel do
        url "https://static.rust-lang.org/dist/2025-12-11/rust-std-1.92.0-x86_64-unknown-linux-gnu.tar.xz", using: :nounzip
        sha256 "5f106805ed86ebf8df287039e53a45cf974391ef4d088c2760776b05b8e48b5d"
      end
    end
  end

  def llvm
    Formula["llvm@21"]
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

    cargo_src_path = buildpath/"src/tools/cargo"
    rm_r(cargo_src_path)
    resource("cargo").stage cargo_src_path
    if OS.mac?
      inreplace cargo_src_path/"Cargo.toml",
                /^curl\s*=\s*"(.+)"$/,
                'curl = { version = "\\1", features = ["force-system-lib-on-osx"] }'
    end

    cache_date = File.basename(File.dirname(resource("rustc-bootstrap").url))
    build_cache_directory = buildpath/"build/cache"/cache_date

    resource("rustc-bootstrap").stage build_cache_directory
    resource("cargo-bootstrap").stage build_cache_directory
    resource("rust-std-bootstrap").stage build_cache_directory

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
      --disable-lld
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
    return unless OS.mac?

    # Replace the renamed llvm-objcopy with a symlink to make sure it can find libLLVM
    arch = Hardware::CPU.arm? ? :aarch64 : Hardware::CPU.arch
    rust_objcopy = lib/"rustlib/#{arch}-apple-darwin/bin/rust-objcopy"
    llvm_objcopy = llvm.opt_bin/"llvm-objcopy"
    rm(rust_objcopy)
    ln_sf llvm_objcopy.relative_path_from(rust_objcopy.dirname), rust_objcopy
  end

  def caveats
    <<~EOS
      Link this toolchain with `rustup` under the name `system` with:
        rustup toolchain link system "$(brew --prefix rust)"

      If you use rustup, avoid PATH conflicts by following instructions in:
        brew info rustup
    EOS
  end

  test do
    require "utils/linkage"

    system bin/"rustdoc", "-h"
    (testpath/"hello.rs").write <<~RUST
      fn main() {
        println!("Hello World!");
      }
    RUST
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
      ]
    end
    missing_linkage = []
    expected_linkage.each do |binary, dylibs|
      dylibs.each do |dylib|
        next if Utils.binary_linked_to_library?(binary, dylib)

        missing_linkage << "#{binary} => #{dylib}"
      end
    end
    assert missing_linkage.empty?, "Missing linkage: #{missing_linkage.join(", ")}"
  end
end
