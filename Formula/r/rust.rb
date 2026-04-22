class Rust < Formula
  desc "Safe, concurrent, practical language"
  homepage "https://www.rust-lang.org/"
  url "https://static.rust-lang.org/dist/rustc-1.95.0-src.tar.gz"
  sha256 "ea9b82a83e46967537c3569ce9d6fa16811c043a96e651376c349e70241ca515"
  license any_of: ["Apache-2.0", "MIT"]
  compatibility_version 1
  head "https://github.com/rust-lang/rust.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "7a737b434cf0308a7d5b8fe96a84f0f080d6fc7254e99694d7bf2761120baf90"
    sha256 cellar: :any,                 arm64_sequoia: "95b1bdf39a2d43f2dd8ce87882af6b7db5554fe5510e3abd61fa215752092168"
    sha256 cellar: :any,                 arm64_sonoma:  "f67006422b732a7221d95f21f7c91e1cbff22286476865e3391ecd8450236845"
    sha256 cellar: :any,                 sonoma:        "2949815437bd707921d9cf7f7d5343697933a0e1f1f81a54bd6d03168195d9dd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "aec45ed59c862c29641ce18338ceb3e37100b8afc40271778e7eb848af267470"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b5760cd41400a3f5b9e0b5e96d1e7f81165be8ee78ad03ac6ecd5161c0477e58"
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
        url "https://static.rust-lang.org/dist/2026-03-05/rustc-1.94.0-aarch64-apple-darwin.tar.xz", using: :nounzip
        sha256 "6ba00a4f486af11826335cd7fe405592d959f50afb9489176fc1463cbe75dbf2"
      end
      on_intel do
        url "https://static.rust-lang.org/dist/2026-03-05/rustc-1.94.0-x86_64-apple-darwin.tar.xz", using: :nounzip
        sha256 "b1374b0fb63f5abcd8eb65607e43a499bfdc5e8160746d1f6f993aee9313f320"
      end
    end

    on_linux do
      on_arm do
        url "https://static.rust-lang.org/dist/2026-03-05/rustc-1.94.0-aarch64-unknown-linux-gnu.tar.xz", using: :nounzip
        sha256 "7261b2fcdb88aef8b21f4b9f915d9a75c959674193f5b38e13fab4569684fc5b"
      end
      on_intel do
        url "https://static.rust-lang.org/dist/2026-03-05/rustc-1.94.0-x86_64-unknown-linux-gnu.tar.xz", using: :nounzip
        sha256 "31a0d3ac9383dfdeb4fce86eeed5ade3230131c635264c0eab7252dbf235f28e"
      end
    end
  end

  # From https://github.com/rust-lang/rust/blob/#{version}/src/stage0
  resource "cargo-bootstrap" do
    on_macos do
      on_arm do
        url "https://static.rust-lang.org/dist/2026-03-05/cargo-1.94.0-aarch64-apple-darwin.tar.xz", using: :nounzip
        sha256 "7497ab873993cf38b806548c85bf818ffd71d1c3cf77b5bb4c3d3f1769588a08"
      end
      on_intel do
        url "https://static.rust-lang.org/dist/2026-03-05/cargo-1.94.0-x86_64-apple-darwin.tar.xz", using: :nounzip
        sha256 "3beb7874010ebd757780284c0c9da47fc9f0b18091d7415d7b7231a8c19ec44f"
      end
    end

    on_linux do
      on_arm do
        url "https://static.rust-lang.org/dist/2026-03-05/cargo-1.94.0-aarch64-unknown-linux-gnu.tar.xz", using: :nounzip
        sha256 "d57ab7b23b52cba46e58c78327904d0c7db19892988677b0d59495c8af4bb790"
      end
      on_intel do
        url "https://static.rust-lang.org/dist/2026-03-05/cargo-1.94.0-x86_64-unknown-linux-gnu.tar.xz", using: :nounzip
        sha256 "8e17624f3de39e079845bfb25ed15a042f4b50ceca78e37c56c4b9b15949b9f7"
      end
    end
  end

  # From https://github.com/rust-lang/rust/blob/#{version}/src/stage0
  resource "rust-std-bootstrap" do
    on_macos do
      on_arm do
        url "https://static.rust-lang.org/dist/2026-03-05/rust-std-1.94.0-aarch64-apple-darwin.tar.xz", using: :nounzip
        sha256 "d3293668128b0a7838ef2544ae341eadd4437460ca22098af723349885a10ba2"
      end
      on_intel do
        url "https://static.rust-lang.org/dist/2026-03-05/rust-std-1.94.0-x86_64-apple-darwin.tar.xz", using: :nounzip
        sha256 "cf716b5a5fab007398ce76536a85a3449df074b66e7c762c0f5de1d6c56a1342"
      end
    end

    on_linux do
      on_arm do
        url "https://static.rust-lang.org/dist/2026-03-05/rust-std-1.94.0-aarch64-unknown-linux-gnu.tar.xz", using: :nounzip
        sha256 "c781b3ef4fefa5508fbe05820eddc95e46351d905a30921cc020febd9c596a2e"
      end
      on_intel do
        url "https://static.rust-lang.org/dist/2026-03-05/rust-std-1.94.0-x86_64-unknown-linux-gnu.tar.xz", using: :nounzip
        sha256 "dd33653107c36e040082050d9e547e64dac5b456ba74069430d838c00c189a05"
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
