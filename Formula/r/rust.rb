class Rust < Formula
  desc "Safe, concurrent, practical language"
  homepage "https://www.rust-lang.org/"
  license any_of: ["Apache-2.0", "MIT"]
  revision 1
  compatibility_version 1
  head "https://github.com/rust-lang/rust.git", branch: "main"

  stable do
    url "https://static.rust-lang.org/dist/rustc-1.99.0-src.tar.gz"
    sha256 "2035e4077b834a42ff8afd07f277ae3f06340098b86b1d2843aa234b4cfcae67"

    # From https://github.com/rust-lang/rust/blob/#{version}/src/stage0
    # HEAD does not use these as it needs a nightly rust
    resource "rustc-bootstrap" do
      on_macos do
        on_arm do
          url "https://static.rust-lang.org/dist/2026-08-20/rustc-1.98.0-aarch64-apple-darwin.tar.xz", using: :nounzip
          sha256 "287edbc2e285b9c23ef7b085413b90cb8539909eda9c4b49f2a55ec0b52819d4"
        end
        on_intel do
          url "https://static.rust-lang.org/dist/2026-08-20/rustc-1.98.0-x86_64-apple-darwin.tar.xz", using: :nounzip
          sha256 "c82d8f536955a9d6fc4465637fce5dcacf1d3913a98b5eb7edd9ead5a8b3f509"
        end
      end
      on_linux do
        on_arm do
          url "https://static.rust-lang.org/dist/2026-08-20/rustc-1.98.0-aarch64-unknown-linux-gnu.tar.xz", using: :nounzip
          sha256 "00590657f2356d7163ca5ef295283523974c340fa21bb94b420ce794f29b358c"
        end
        on_intel do
          url "https://static.rust-lang.org/dist/2026-08-20/rustc-1.98.0-x86_64-unknown-linux-gnu.tar.xz", using: :nounzip
          sha256 "0e37cb339f447fc44d6d781073bacacebfdc5612f2600e4c7e84c266f5f3aced"
        end
      end
    end

    # From https://github.com/rust-lang/rust/blob/#{version}/src/stage0
    resource "cargo-bootstrap" do
      on_macos do
        on_arm do
          url "https://static.rust-lang.org/dist/2026-08-20/cargo-1.98.0-aarch64-apple-darwin.tar.xz", using: :nounzip
          sha256 "2c2a8bbf3cba4353c0ca2cf1ba8280603f3ca82ceebb538fee4a1a987147f743"
        end
        on_intel do
          url "https://static.rust-lang.org/dist/2026-08-20/cargo-1.98.0-x86_64-apple-darwin.tar.xz", using: :nounzip
          sha256 "3526be8588e7f80cf0604ce184dd8af89798786e389d5deea4ae4ffe2f104265"
        end
      end
      on_linux do
        on_arm do
          url "https://static.rust-lang.org/dist/2026-08-20/cargo-1.98.0-aarch64-unknown-linux-gnu.tar.xz", using: :nounzip
          sha256 "5784379d73ac881d15a9e67eed2882cd58c747c276221c23cdf9aff37e015ff6"
        end
        on_intel do
          url "https://static.rust-lang.org/dist/2026-08-20/cargo-1.98.0-x86_64-unknown-linux-gnu.tar.xz", using: :nounzip
          sha256 "2f512d170d3dd23e16ababcda32ee2e6d5172d861a7af1f504e0b1e270cafab9"
        end
      end
    end

    # From https://github.com/rust-lang/rust/blob/#{version}/src/stage0
    resource "rust-std-bootstrap" do
      on_macos do
        on_arm do
          url "https://static.rust-lang.org/dist/2026-08-20/rust-std-1.98.0-aarch64-apple-darwin.tar.xz", using: :nounzip
          sha256 "48c05269ed36fb5f0a8438065156891fe59fcb868d90cfed9b7209540d54b2ce"
        end
        on_intel do
          url "https://static.rust-lang.org/dist/2026-08-20/rust-std-1.98.0-x86_64-apple-darwin.tar.xz", using: :nounzip
          sha256 "8923fa9d0e0407b8a492e59d568e7aceff75949e1eee2e3e1b60e174373890cb"
        end
      end
      on_linux do
        on_arm do
          url "https://static.rust-lang.org/dist/2026-08-20/rust-std-1.98.0-aarch64-unknown-linux-gnu.tar.xz", using: :nounzip
          sha256 "a36f7ac98af20ef0ba6368aace0345efabbebaef7962eba99f47190fd256162d"
        end
        on_intel do
          url "https://static.rust-lang.org/dist/2026-08-20/rust-std-1.98.0-x86_64-unknown-linux-gnu.tar.xz", using: :nounzip
          sha256 "f5022e6c95a5ad23cca2513dc8281200f585fa188de6370aa37b128a43f876a3"
        end
      end
    end
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "7525422d522cb4fafca1441ab42ace810b590edc540f93ad14a81bdee157de99"
    sha256 cellar: :any, arm64_tahoe:       "9fd7f9b81fa70767432e1cd6cab9b945ab7a4297529b5e3f95fc2663e512b2f5"
    sha256 cellar: :any, arm64_sequoia:     "ab2aad7448f020d2ceb660ef75ba79d06761f91d8afc29071b8e9a1bf99af8ca"
    sha256 cellar: :any, arm64_linux:       "7587563b8bd5a17d0846cba46d41ccac9d45cdbf6554eeaf95f8504db79b4e36"
    sha256 cellar: :any, x86_64_linux:      "06952c11381a7519c1e10b9b455942f0965c0f44dd6246cd4e4e29b3b85dee42"
  end

  depends_on "libgit2"
  depends_on "libssh2"
  depends_on "llvm"
  depends_on "openssl@4"
  depends_on "pkgconf"
  depends_on "sqlite"

  uses_from_macos "python" => :build
  uses_from_macos "curl"

  # Required by Rust, see https://github.com/rust-lang/rust/issues/39870
  preserve_rpath

  link_overwrite "etc/bash_completion.d/cargo"
  # These used to belong in `rustfmt`.
  link_overwrite "bin/cargo-fmt", "bin/git-rustfmt", "bin/rustfmt", "bin/rustfmt-*"

  def llvm = deps.map(&:name).find { |dep| dep.match?(/^llvm(@\d+)?$/) }

  def openssl = deps.map(&:name).find { |dep| dep.start_with?("openssl@") }

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    # https://docs.rs/openssl/latest/openssl/#manual
    ENV["OPENSSL_DIR"] = formula_opt_prefix(openssl)

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

    if build.stable?
      # Verify resource versions otherwise the build script will download them
      # TODO: `deny_network_access!` can help but will break HEAD build
      bootstrap_version = File.read("src/stage0")[/^compiler_version=v?(\d+(?:\.\d+)+)$/, 1]
      if (resource_version = resource("rustc-bootstrap").version) != bootstrap_version
        odie "Expected #{bootstrap_version} for bootstrap but got #{resource_version}!"
      end

      cache_date = File.basename(File.dirname(resource("rustc-bootstrap").url))
      build_cache_directory = buildpath/"build/cache"/cache_date

      resource("rustc-bootstrap").stage build_cache_directory
      resource("cargo-bootstrap").stage build_cache_directory
      resource("rust-std-bootstrap").stage build_cache_directory
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
      --llvm-root=#{formula_opt_prefix(llvm)}
      --enable-llvm-link-shared
      --enable-profiler
      --enable-vendor
      --disable-cargo-native-static
      --disable-docs
      --disable-lld
      --release-channel=#{build.head? ? "nightly" : "stable"}
      --release-description=#{tap.user}
      --set=build.allocator=jemalloc
    ]
    # Restrict slower optimizations to bottling
    # https://github.com/rust-lang/rust/blob/main/src/doc/rustc-dev-guide/src/building/optimized-build.md
    if build.bottle?
      args += %w[
        --set=rust.lto=thin
        --set=rust.codegen-units=1
      ]
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
    llvm_objcopy = formula_opt_bin(llvm)/"llvm-objcopy"
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
        formula_opt_lib(openssl)/shared_library("libssl"),
      ],
    }
    expected_linkage[bin/"cargo"] << if OS.mac?
      formula_opt_lib(openssl)/shared_library("libcrypto")
    else
      formula_opt_lib("curl")/shared_library("libcurl")
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
