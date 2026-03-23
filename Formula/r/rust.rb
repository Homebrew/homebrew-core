class Rust < Formula
  desc "Safe, concurrent, practical language"
  homepage "https://www.rust-lang.org/"
  license any_of: ["Apache-2.0", "MIT"]

  compatibility_version 1

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
    sha256 cellar: :any,                 arm64_tahoe:   "d5e00e29ea3544d11dbd1d8e120d168154608ffd5fe4eb62336f4639193d258d"
    sha256 cellar: :any,                 arm64_sequoia: "7301c72f0da263d62c773093d3dd2da52baa98f24ac60044b6e06872465356d8"
    sha256 cellar: :any,                 arm64_sonoma:  "d670fe3a67bd2925a94b0e3e569f0ba4ad29b3078c35b4035addb4aa4b2242fb"
    sha256 cellar: :any,                 sonoma:        "15a40611dcae240d8f831e0af6381345ea89c83a6f3abe66675a29cc6fcd67eb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "462b4a8b12744b7d06c8d6488de6ead2af403eed8aea2e868cf7dbe684f4f21c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "53e7f45c1a40611f896918ef8d2c09127e123dd364cf53213e08fb4f4d5d9b10"
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
        url "https://static.rust-lang.org/dist/2026-01-22/rustc-1.93.0-aarch64-apple-darwin.tar.xz", using: :nounzip
        sha256 "092be03c02b44c405dab1232541c84f32b2d9e8295747568c3d531dd137221dc"
      end
      on_intel do
        url "https://static.rust-lang.org/dist/2026-01-22/rustc-1.93.0-x86_64-apple-darwin.tar.xz", using: :nounzip
        sha256 "594bb293f0a4f444656cf8dec2149fcb979c606260efee9e09bcf8c9c6ed6ae7"
      end
    end

    on_linux do
      on_arm do
        url "https://static.rust-lang.org/dist/2026-01-22/rustc-1.93.0-aarch64-unknown-linux-gnu.tar.xz", using: :nounzip
        sha256 "1a9045695892ec08d8e9751bf7cf7db71fe27a6202dd12ce13aca48d0602dbde"
      end
      on_intel do
        url "https://static.rust-lang.org/dist/2026-01-22/rustc-1.93.0-x86_64-unknown-linux-gnu.tar.xz", using: :nounzip
        sha256 "00c6e6740ea6a795e33568cd7514855d58408a1180cd820284a7bbf7c46af715"
      end
    end
  end

  # From https://github.com/rust-lang/rust/blob/#{version}/src/stage0
  resource "cargo-bootstrap" do
    on_macos do
      on_arm do
        url "https://static.rust-lang.org/dist/2026-01-22/cargo-1.93.0-aarch64-apple-darwin.tar.xz", using: :nounzip
        sha256 "6443909350322ad07f09bb5edfd9ff29268e6fe88c7d78bfba7a5e254248dc25"
      end
      on_intel do
        url "https://static.rust-lang.org/dist/2026-01-22/cargo-1.93.0-x86_64-apple-darwin.tar.xz", using: :nounzip
        sha256 "95a47c5ed797c35419908f04188d8b7de09946e71073c4b72632b16f5b10dfae"
      end
    end

    on_linux do
      on_arm do
        url "https://static.rust-lang.org/dist/2026-01-22/cargo-1.93.0-aarch64-unknown-linux-gnu.tar.xz", using: :nounzip
        sha256 "5998940b8b97286bb67facb1a85535eeb3d4d7a61e36a85e386e5c0c5cfe5266"
      end
      on_intel do
        url "https://static.rust-lang.org/dist/2026-01-22/cargo-1.93.0-x86_64-unknown-linux-gnu.tar.xz", using: :nounzip
        sha256 "c23de3ae709ff33eed5e4ae59d1f9bcd75fa4dbaa9fb92f7b06bfb534b8db880"
      end
    end
  end

  # From https://github.com/rust-lang/rust/blob/#{version}/src/stage0
  resource "rust-std-bootstrap" do
    on_macos do
      on_arm do
        url "https://static.rust-lang.org/dist/2026-01-22/rust-std-1.93.0-aarch64-apple-darwin.tar.xz", using: :nounzip
        sha256 "8603c63715349636ed85b4fe716c4e827a727918c840e54aff5b243cedadf19b"
      end
      on_intel do
        url "https://static.rust-lang.org/dist/2026-01-22/rust-std-1.93.0-x86_64-apple-darwin.tar.xz", using: :nounzip
        sha256 "f112d41c8a31794f0f561d37fe77010ed0b405fa70284a2910891869d8c52418"
      end
    end

    on_linux do
      on_arm do
        url "https://static.rust-lang.org/dist/2026-01-22/rust-std-1.93.0-aarch64-unknown-linux-gnu.tar.xz", using: :nounzip
        sha256 "84e82ff52c39c64dfd0e1c2d58fd3d5309d1d2502378131544c0d486b44af20a"
      end
      on_intel do
        url "https://static.rust-lang.org/dist/2026-01-22/rust-std-1.93.0-x86_64-unknown-linux-gnu.tar.xz", using: :nounzip
        sha256 "a849a418d0f27e69573e41763c395e924a0b98c16fcdc55599c1c79c27c1c777"
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
