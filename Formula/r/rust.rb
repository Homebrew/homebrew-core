class Rust < Formula
  desc "Safe, concurrent, practical language"
  homepage "https://www.rust-lang.org/"
  license any_of: ["Apache-2.0", "MIT"]
  compatibility_version 1
  head "https://github.com/rust-lang/rust.git", branch: "main"

  stable do
    url "https://static.rust-lang.org/dist/rustc-1.98.1-src.tar.gz"
    sha256 "dc9f8b917b32444d6c7ac43cc1b409013d3a9a633338bb60c14cdae1d15ee65a"

    # From https://github.com/rust-lang/rust/blob/#{version}/src/stage0
    # HEAD does not use these as it needs a nightly rust
    resource "rustc-bootstrap" do
      on_macos do
        on_arm do
          url "https://static.rust-lang.org/dist/2026-07-16/rustc-1.97.1-aarch64-apple-darwin.tar.xz", using: :nounzip
          sha256 "6076cad38ccabaa24325f26a74080a363a2633a9cd34c473a8977255d8a593cb"
        end
        on_intel do
          url "https://static.rust-lang.org/dist/2026-07-16/rustc-1.97.1-x86_64-apple-darwin.tar.xz", using: :nounzip
          sha256 "3c38289f319bf02fa1c8149ce3e00f261e4efd14813a99f7f7ae4f180c7d1173"
        end
      end

      on_linux do
        on_arm do
          url "https://static.rust-lang.org/dist/2026-07-16/rustc-1.97.1-aarch64-unknown-linux-gnu.tar.xz", using: :nounzip
          sha256 "b344b81f0cd4c2246c7da8b197fe7a339d7dd02bb15cb69b2524115d9c75224c"
        end
        on_intel do
          url "https://static.rust-lang.org/dist/2026-07-16/rustc-1.97.1-x86_64-unknown-linux-gnu.tar.xz", using: :nounzip
          sha256 "9819d0a32d56bd339585319c80260e332779f5541fd66838ab7e016d6c814819"
        end
      end
    end

    # From https://github.com/rust-lang/rust/blob/#{version}/src/stage0
    resource "cargo-bootstrap" do
      on_macos do
        on_arm do
          url "https://static.rust-lang.org/dist/2026-07-16/cargo-1.97.1-aarch64-apple-darwin.tar.xz", using: :nounzip
          sha256 "2d84a74e9558192a7de674aca6aa3ab7464bed2df97e0377156ddb7e09a0fd7a"
        end
        on_intel do
          url "https://static.rust-lang.org/dist/2026-07-16/cargo-1.97.1-x86_64-apple-darwin.tar.xz", using: :nounzip
          sha256 "1bd1029b579d0563ca851ebd095914871535bfd1978a123eeaa03107e89b0e03"
        end
      end

      on_linux do
        on_arm do
          url "https://static.rust-lang.org/dist/2026-07-16/cargo-1.97.1-aarch64-unknown-linux-gnu.tar.xz", using: :nounzip
          sha256 "8f70bcaccea5ba4db187c3fd4d64e24592b4e16af513497201f5909d61691dbe"
        end
        on_intel do
          url "https://static.rust-lang.org/dist/2026-07-16/cargo-1.97.1-x86_64-unknown-linux-gnu.tar.xz", using: :nounzip
          sha256 "e1be5f5ff7f7f80ca506fb65770b759edbdc6d303781ed71c5de8ec8a8394779"
        end
      end
    end

    # From https://github.com/rust-lang/rust/blob/#{version}/src/stage0
    resource "rust-std-bootstrap" do
      on_macos do
        on_arm do
          url "https://static.rust-lang.org/dist/2026-07-16/rust-std-1.97.1-aarch64-apple-darwin.tar.xz", using: :nounzip
          sha256 "a4895f5c6995e83cab8687e46b14324592398049def71ce75ca308c981cf200d"
        end
        on_intel do
          url "https://static.rust-lang.org/dist/2026-07-16/rust-std-1.97.1-x86_64-apple-darwin.tar.xz", using: :nounzip
          sha256 "0fa78653023be5bdfeb419edc82e3b1346ccaa23eaa036491cce084101c741dd"
        end
      end

      on_linux do
        on_arm do
          url "https://static.rust-lang.org/dist/2026-07-16/rust-std-1.97.1-aarch64-unknown-linux-gnu.tar.xz", using: :nounzip
          sha256 "46aed8e63186350004d8ec6afca798811e6530b514352e5a8a26f3dc4939b3be"
        end
        on_intel do
          url "https://static.rust-lang.org/dist/2026-07-16/rust-std-1.97.1-x86_64-unknown-linux-gnu.tar.xz", using: :nounzip
          sha256 "1c1e704ae80126b7de34f72ea2825f7fd01736dec20732faed47374b95282fba"
        end
      end
    end
  end

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_golden_gate: "4f7a53e41a47784a74dd84acb836e33c425c3f7fb6715aed602c188800da603f"
    sha256 cellar: :any, arm64_tahoe:       "409411d3aacd29a2528ca290f5fbbaca4acb2f1db8fa44c3d30480c30e79231b"
    sha256 cellar: :any, arm64_sequoia:     "4a1bbbb08569ac2f1837bed5ce931e707f6c4666118d933f6372cb9438d7794a"
    sha256 cellar: :any, arm64_sonoma:      "5928033c1a2b6639206995f9adf81d82d1d29fa4c7364628fb3e68b031b6d61e"
    sha256 cellar: :any, arm64_linux:       "3f53535b1c1bc548a7282e6c23beaca99def881a5786354aba04d0cb3f572166"
    sha256 cellar: :any, x86_64_linux:      "b42a09b9ba34ccbce8b84e0e8bce44680360c1ff261a3bd952fc586e6c7bd04c"
  end

  depends_on "libgit2"
  depends_on "libssh2"
  depends_on "llvm@22"
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

  def llvm
    Formula["llvm@22"]
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

    if build.stable?
      # Verify resource versions otherwise the build script will download them
      # TODO: `deny_network_access!` can help but will break HEAD build
      bootstrap_version = File.read("src/stage0")[/^compiler_version=v?(\d+(?:\.\d+)+)$/, 1]
      if (resource_version = resource("rustc-bootstrap").version) != bootstrap_version
        odie "Expected #{bootstrap_version} for bootstrap but got #{resource_version}!"
      end
      # Apply same workaround as MacPorts to build on macOS 27 which hits
      # https://github.com/rust-lang/rust/issues/157750 in bootstrap
      # TODO: Remove in 1.99.0
      odie "Remove CARGO_PROFILE_DEV_STRIP workaround!" if bootstrap_version >= "1.98.0"
      ENV["CARGO_PROFILE_DEV_STRIP"] = "none" if OS.mac? && MacOS.version >= :golden_gate

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
      --llvm-root=#{llvm.opt_prefix}
      --enable-llvm-link-shared
      --enable-profiler
      --enable-vendor
      --disable-cargo-native-static
      --disable-docs
      --disable-lld
      --release-description=#{tap.user}
    ]
    if build.head?
      args << "--disable-rpath"
      args << "--release-channel=nightly"
      args << "--set=build.allocator=jemalloc"
    else
      args << "--release-channel=stable"
      args << "--set=rust.jemalloc" # TODO: use `--set=build.allocator=jemalloc` in 1.99.0 as old arg is deprecated
    end
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
        formula_opt_lib("openssl@3")/shared_library("libssl"),
      ],
    }
    expected_linkage[bin/"cargo"] << if OS.mac?
      formula_opt_lib("openssl@3")/shared_library("libcrypto")
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
