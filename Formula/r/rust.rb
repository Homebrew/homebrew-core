class Rust < Formula
  desc "Safe, concurrent, practical language"
  homepage "https://www.rust-lang.org/"
  url "https://static.rust-lang.org/dist/rustc-1.96.1-src.tar.gz"
  sha256 "d0a9b5198c41868538ae12af28064163551d06dcceab11ef0b1bc9aa6e98b7a7"
  license any_of: ["Apache-2.0", "MIT"]
  compatibility_version 1
  head "https://github.com/rust-lang/rust.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "d925479583e45556833b1b4f29d9a303593d65b67d04eb0802f0f480b32a6d5f"
    sha256 cellar: :any, arm64_sequoia: "759effbbb6930ad939322c07cff6e9ba4823d60119a7620f556376839f5f3c1d"
    sha256 cellar: :any, arm64_sonoma:  "a2fa64df46d3a50fac9b4416c729d82ea468a1516e3d605e1783c06b888067d0"
    sha256 cellar: :any, sonoma:        "0ad6fa8e926cdeab08795b8dcca618f4eacb10865e94d99c281565023dee6a16"
    sha256 cellar: :any, arm64_linux:   "958a5b3ca8a90d406a8b4b36190c05978405c0cbb4a83d18a4937df94bdd0ad3"
    sha256 cellar: :any, x86_64_linux:  "4fad946179ee9daa02c95ac8a677f5d1295cbed03e1164a42802814f4a8c7cef"
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
        url "https://static.rust-lang.org/dist/2026-04-16/rustc-1.95.0-aarch64-apple-darwin.tar.xz", using: :nounzip
        sha256 "149e85a285b6eba58eb6c8bdf7deb1b93763890598e62cb635a712e3a8454f04"
      end
      on_intel do
        url "https://static.rust-lang.org/dist/2026-04-16/rustc-1.95.0-x86_64-apple-darwin.tar.xz", using: :nounzip
        sha256 "33db457715446a69ed6f69f78f5fbb9ca8e17a16585d1d7a0060479bfe4c7afc"
      end
    end

    on_linux do
      on_arm do
        url "https://static.rust-lang.org/dist/2026-04-16/rustc-1.95.0-aarch64-unknown-linux-gnu.tar.xz", using: :nounzip
        sha256 "0fe3689eeaed603e5ef24572d11597d3edadaefd2cb181674ad621260f2501d2"
      end
      on_intel do
        url "https://static.rust-lang.org/dist/2026-04-16/rustc-1.95.0-x86_64-unknown-linux-gnu.tar.xz", using: :nounzip
        sha256 "8426a3d170a5879f5682f5fbdd024a1779b3951e7baba685af2d6dc32a6dfc15"
      end
    end
  end

  # From https://github.com/rust-lang/rust/blob/#{version}/src/stage0
  resource "cargo-bootstrap" do
    on_macos do
      on_arm do
        url "https://static.rust-lang.org/dist/2026-04-16/cargo-1.95.0-aarch64-apple-darwin.tar.xz", using: :nounzip
        sha256 "6c2ffed8e1ac9cf4dc9e80f282a869a6b237a153e7c55cca039d33de29d80aaf"
      end
      on_intel do
        url "https://static.rust-lang.org/dist/2026-04-16/cargo-1.95.0-x86_64-apple-darwin.tar.xz", using: :nounzip
        sha256 "e2e1131ade2dddc0d779e0ab3a6a990085c7a654951235742823c3a1ce0f190f"
      end
    end

    on_linux do
      on_arm do
        url "https://static.rust-lang.org/dist/2026-04-16/cargo-1.95.0-aarch64-unknown-linux-gnu.tar.xz", using: :nounzip
        sha256 "7c070aeba9bbf12073646995a03f36c346bb5f541d0078ba6d9dc2a7adaaf6af"
      end
      on_intel do
        url "https://static.rust-lang.org/dist/2026-04-16/cargo-1.95.0-x86_64-unknown-linux-gnu.tar.xz", using: :nounzip
        sha256 "e74edd2cf7d0f1f1383b4f00eb90c843750bc489e2ccf7214e6476678a907425"
      end
    end
  end

  # From https://github.com/rust-lang/rust/blob/#{version}/src/stage0
  resource "rust-std-bootstrap" do
    on_macos do
      on_arm do
        url "https://static.rust-lang.org/dist/2026-04-16/rust-std-1.95.0-aarch64-apple-darwin.tar.xz", using: :nounzip
        sha256 "9b30089b0f767cb91b2190ffec55a9beeb2a21a1405d8da0f664d7e09d08e6d8"
      end
      on_intel do
        url "https://static.rust-lang.org/dist/2026-04-16/rust-std-1.95.0-x86_64-apple-darwin.tar.xz", using: :nounzip
        sha256 "2be13c14122b8d4d09b7f7c434fca9ae7215ec72049944189c88c4d9128ce504"
      end
    end

    on_linux do
      on_arm do
        url "https://static.rust-lang.org/dist/2026-04-16/rust-std-1.95.0-aarch64-unknown-linux-gnu.tar.xz", using: :nounzip
        sha256 "3a21b271b1ff973b94d69b25e7a39992f9fbcae1ab6d9475844a23e6ad3908ac"
      end
      on_intel do
        url "https://static.rust-lang.org/dist/2026-04-16/rust-std-1.95.0-x86_64-unknown-linux-gnu.tar.xz", using: :nounzip
        sha256 "047ea7098803d3500fa1072e9cee5392697e21525559e4458128a2bf874aa382"
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
