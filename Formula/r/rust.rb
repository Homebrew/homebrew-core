class Rust < Formula
  desc "Safe, concurrent, practical language"
  homepage "https://www.rust-lang.org/"
  license any_of: ["Apache-2.0", "MIT"]

  stable do
    url "https://static.rust-lang.org/dist/rustc-1.91.1-src.tar.gz"
    sha256 "38dce205d39f61571261f0444237a1ce9efecb970e760d8ec4d957af5b445723"

    # From https://github.com/rust-lang/rust/tree/#{version}/src/tools
    resource "cargo" do
      url "https://github.com/rust-lang/cargo/archive/refs/tags/0.92.0.tar.gz"
      sha256 "58048da121cf8707ae536e44220a5620d8102cfa6c7a3e32c404d357f0c5a286"
    end
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "36b63a5a652a2080f8fb351b4e510d1dc5377cb6dd1e09001ee2e96a1e277c17"
    sha256 cellar: :any,                 arm64_sequoia: "395669770ae8c4e8794418bfc40826d9e962f48edb1720811b89c0ddf5c1dcbc"
    sha256 cellar: :any,                 arm64_sonoma:  "c3e8a00ee3785812eef4a56264e220185778ed142a46993edfadc43cab805beb"
    sha256 cellar: :any,                 sonoma:        "14701fe5acdf435382821957e3596be783aa29440cec2e9a1b2c7c79579bc752"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5dfd7a618a789b6fdebd2249dcc684538929f86ba0be90a460db36c57d541a1f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "90f5836d4ace4769eef7ce3bc0a501388b2c70191438cad5710a80c69df2e768"
  end

  head do
    url "https://github.com/rust-lang/rust.git", branch: "main"

    resource "cargo" do
      url "https://github.com/rust-lang/cargo.git", branch: "master"
    end
  end

  depends_on "libgit2"
  depends_on "libssh2"
  depends_on "llvm"
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
        url "https://static.rust-lang.org/dist/2025-09-18/rustc-1.90.0-aarch64-apple-darwin.tar.xz", using: :nounzip
        sha256 "89551c0ba1cc6d0312aebc4a6cafe4497223217ea8e87c81f6afbe127dfaeeb6"
      end
      on_intel do
        url "https://static.rust-lang.org/dist/2025-09-18/rustc-1.90.0-x86_64-apple-darwin.tar.xz", using: :nounzip
        sha256 "594687a61b671445ea9fff0e6b6c6eef81cba30b005d22710217b4da8d2d2ecc"
      end
    end

    on_linux do
      on_arm do
        url "https://static.rust-lang.org/dist/2025-09-18/rustc-1.90.0-aarch64-unknown-linux-gnu.tar.xz", using: :nounzip
        sha256 "4e1a9987a11d7d91f0d5afbf5333feb62f44172e4a31f33ce7246549003217f2"
      end
      on_intel do
        url "https://static.rust-lang.org/dist/2025-09-18/rustc-1.90.0-x86_64-unknown-linux-gnu.tar.xz", using: :nounzip
        sha256 "48c2a42de9e92fcae8c24568f5fe40d5734696a6f80e83cc6d46eef1a78f13c9"
      end
    end
  end

  # From https://github.com/rust-lang/rust/blob/#{version}/src/stage0
  resource "cargo-bootstrap" do
    on_macos do
      on_arm do
        url "https://static.rust-lang.org/dist/2025-09-18/cargo-1.90.0-aarch64-apple-darwin.tar.xz", using: :nounzip
        sha256 "17a4410a27bf7dad4765f3809265c225f25f8b009da3d4b76cd0927acdae04b5"
      end
      on_intel do
        url "https://static.rust-lang.org/dist/2025-09-18/cargo-1.90.0-x86_64-apple-darwin.tar.xz", using: :nounzip
        sha256 "b2fa21c8fed854775e379bb4617145abd047d1be729e8383148139ba1d05c88f"
      end
    end

    on_linux do
      on_arm do
        url "https://static.rust-lang.org/dist/2025-09-18/cargo-1.90.0-aarch64-unknown-linux-gnu.tar.xz", using: :nounzip
        sha256 "bd8d1da6fe88ea7e29338f24277c22156267447adbfc47d690467ad32d02c2a7"
      end
      on_intel do
        url "https://static.rust-lang.org/dist/2025-09-18/cargo-1.90.0-x86_64-unknown-linux-gnu.tar.xz", using: :nounzip
        sha256 "9853db03d68578a30972e2755c89c66aec035fec641cf8f3a7117c81eec2578d"
      end
    end
  end

  # From https://github.com/rust-lang/rust/blob/#{version}/src/stage0
  resource "rust-std-bootstrap" do
    on_macos do
      on_arm do
        url "https://static.rust-lang.org/dist/2025-09-18/rust-std-1.90.0-aarch64-apple-darwin.tar.xz", using: :nounzip
        sha256 "c36777aec17d617f85f94b7cb87bdd4270eeca30ef38c6f686809d163c881609"
      end
      on_intel do
        url "https://static.rust-lang.org/dist/2025-09-18/rust-std-1.90.0-x86_64-apple-darwin.tar.xz", using: :nounzip
        sha256 "dd731e6f9f30cb9b2928b92b084d2f12a3abf06a481ecbd8c3553c3e6f742139"
      end
    end

    on_linux do
      on_arm do
        url "https://static.rust-lang.org/dist/2025-09-18/rust-std-1.90.0-aarch64-unknown-linux-gnu.tar.xz", using: :nounzip
        sha256 "4952abb7d9d3ed7cea4f7ea44dcb23dc67631fae4ac44a5f059b90a4b5e9223f"
      end
      on_intel do
        url "https://static.rust-lang.org/dist/2025-09-18/rust-std-1.90.0-x86_64-unknown-linux-gnu.tar.xz", using: :nounzip
        sha256 "663f4ab7945b392d5e5294dec1b050a66820a20e86f084ec37eeb0f2f7ff5569"
      end
    end
  end

  def llvm
    Formula["llvm"]
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
