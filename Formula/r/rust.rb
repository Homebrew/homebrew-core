class Rust < Formula
  desc "Safe, concurrent, practical language"
  homepage "https://www.rust-lang.org/"
  url "https://static.rust-lang.org/dist/rustc-1.97.1-src.tar.gz"
  sha256 "622c2b429c53cbfdc0dd3a51d03554e91cd63ebec1912c1f5709640cdfef1a9d"
  license any_of: ["Apache-2.0", "MIT"]
  compatibility_version 1
  head "https://github.com/rust-lang/rust.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "87ad7cb4794cd3f71fec2421551a194093495cab24d7bbca6b58388389e5bee2"
    sha256 cellar: :any, arm64_sequoia: "6400607a427bc326262ec57775d66f56f0b043d373fd6edae65a9d3bbb87e91e"
    sha256 cellar: :any, arm64_sonoma:  "daa91e45a7bcc6a145dc35fcb6e3afc8496c1dc5ef5134b010a0b29683b35534"
    sha256 cellar: :any, sonoma:        "9690452bd6994c91256d5a01ef778c0c6b3dffc05628bc75ad2f787d4fe193dc"
    sha256 cellar: :any, arm64_linux:   "a50c082a879bc1998d2af5f94067a603bbcb58f6246a8b53441adecff4752545"
    sha256 cellar: :any, x86_64_linux:  "677b22aec0231eb985c0cbf30ad84923761b0e6ee300d47d16d93b866e8adb85"
  end

  depends_on "libgit2"
  depends_on "libssh2"
  depends_on "llvm"
  depends_on "openssl@3"
  depends_on "pkgconf"
  depends_on "sqlite"

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
        url "https://static.rust-lang.org/dist/2026-05-28/rustc-1.96.0-aarch64-apple-darwin.tar.xz", using: :nounzip
        sha256 "1bb7b0bad1d2a42fc4173ede6dd460de2774fc1858a8369329d3e081e4e3426c"
      end
      on_intel do
        url "https://static.rust-lang.org/dist/2026-05-28/rustc-1.96.0-x86_64-apple-darwin.tar.xz", using: :nounzip
        sha256 "f503815fe9e8cf6d654f751532932b6a9b13b8615a40fc6dfb9760a18cf595a1"
      end
    end

    on_linux do
      on_arm do
        url "https://static.rust-lang.org/dist/2026-05-28/rustc-1.96.0-aarch64-unknown-linux-gnu.tar.xz", using: :nounzip
        sha256 "76b1a6e8dd1636e364d4bbba685485ff44eee5ff6434add089bab4c703c7e19d"
      end
      on_intel do
        url "https://static.rust-lang.org/dist/2026-05-28/rustc-1.96.0-x86_64-unknown-linux-gnu.tar.xz", using: :nounzip
        sha256 "7d7fa1d0cfb0fab71a956bb78f41107202c17f30ab56c45288e869a37fd9633d"
      end
    end
  end

  # From https://github.com/rust-lang/rust/blob/#{version}/src/stage0
  resource "cargo-bootstrap" do
    on_macos do
      on_arm do
        url "https://static.rust-lang.org/dist/2026-05-28/cargo-1.96.0-aarch64-apple-darwin.tar.xz", using: :nounzip
        sha256 "c042858192b7b6d66fe59b3bbbbd0f6e3cac6e8a478dc4cc091cde9eddea3c8b"
      end
      on_intel do
        url "https://static.rust-lang.org/dist/2026-05-28/cargo-1.96.0-x86_64-apple-darwin.tar.xz", using: :nounzip
        sha256 "23390ad69f74f3464774f17058f803e19cf45a9a11ee725b7a37e96c549f1243"
      end
    end

    on_linux do
      on_arm do
        url "https://static.rust-lang.org/dist/2026-05-28/cargo-1.96.0-aarch64-unknown-linux-gnu.tar.xz", using: :nounzip
        sha256 "09ea03e74aa94e07db7bc00bd2ec1ad86d90a7348c89fde3909a8922543b949f"
      end
      on_intel do
        url "https://static.rust-lang.org/dist/2026-05-28/cargo-1.96.0-x86_64-unknown-linux-gnu.tar.xz", using: :nounzip
        sha256 "dee75c3c8f9f600ad75bc0c93249e767d3047845a4dd668327ce43ab039ba266"
      end
    end
  end

  # From https://github.com/rust-lang/rust/blob/#{version}/src/stage0
  resource "rust-std-bootstrap" do
    on_macos do
      on_arm do
        url "https://static.rust-lang.org/dist/2026-05-28/rust-std-1.96.0-aarch64-apple-darwin.tar.xz", using: :nounzip
        sha256 "439c4f71060b913e00db3a2e01340b2da0aa49978b843e36871f3250267c63f8"
      end
      on_intel do
        url "https://static.rust-lang.org/dist/2026-05-28/rust-std-1.96.0-x86_64-apple-darwin.tar.xz", using: :nounzip
        sha256 "afabf23aff5bf6d27dba9608a7c7bec349bf9fda9c3e37983dd5cc44c9afbcca"
      end
    end

    on_linux do
      on_arm do
        url "https://static.rust-lang.org/dist/2026-05-28/rust-std-1.96.0-aarch64-unknown-linux-gnu.tar.xz", using: :nounzip
        sha256 "538e85452709687797d990579a491ff9b02f8bffba4a5d54cfa945e28868053e"
      end
      on_intel do
        url "https://static.rust-lang.org/dist/2026-05-28/rust-std-1.96.0-x86_64-unknown-linux-gnu.tar.xz", using: :nounzip
        sha256 "c09c7c646248f14f473f5f7a029af15ee57c3a9f9bc93dfa72d9621938586b82"
      end
    end
  end

  def llvm
    Formula["llvm"]
  end

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    # https://docs.rs/openssl/latest/openssl/#manual
    ENV["OPENSSL_DIR"] = formula_opt_prefix("openssl@3")

    ENV["LIBGIT2_NO_VENDOR"] = "1"
    ENV["LIBSQLITE3_SYS_USE_PKG_CONFIG"] = "1"
    ENV["LIBSSH2_SYS_USE_PKG_CONFIG"] = "1"

    if OS.mac?
      # Requires the CLT to be the active developer directory if Xcode is installed
      ENV["SDKROOT"] = MacOS.sdk_path
      # Fix build failure for compiler_builtins "error: invalid deployment target
      # for -stdlib=libc++ (requires OS X 10.7 or later)"
      ENV["MACOSX_DEPLOYMENT_TARGET"] = MacOS.version

      inreplace "src/tools/cargo/Cargo.toml",
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
        formula_opt_lib("libgit2")/shared_library("libgit2"),
        formula_opt_lib("libssh2")/shared_library("libssh2"),
        formula_opt_lib("openssl@3")/shared_library("libcrypto"),
        formula_opt_lib("openssl@3")/shared_library("libssl"),
      ],
    }
    unless OS.mac?
      expected_linkage[bin/"cargo"] += [
        formula_opt_lib("curl")/shared_library("libcurl"),
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
