class Rust < Formula
  desc "Safe, concurrent, practical language"
  homepage "https://www.rust-lang.org/"
  license any_of: ["Apache-2.0", "MIT"]

  stable do
    url "https://static.rust-lang.org/dist/rustc-1.92.0-src.tar.gz"
    sha256 "9e0d2ca75c7e275fdc758255bf4b03afb3d65d1543602746907c933b6901c3b8"

    # From https://github.com/rust-lang/rust/tree/#{version}/src/tools
    resource "cargo" do
      url "https://github.com/rust-lang/cargo/archive/refs/tags/0.93.0.tar.gz"
      sha256 "03a675ae1d0e34599f1fdd500a9b76d780314c1546ffe8230e36775fc4a29d71"
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "b46ed380992d6701c283c1b2cede6c0264cfc5520f6fddebb451ea256195aa50"
    sha256 cellar: :any,                 arm64_sequoia: "1c5e48e47cf36b37e9a44e99b0cc8820443ff2a022c5f5d8702ec3d6af27be56"
    sha256 cellar: :any,                 arm64_sonoma:  "d33db88da6c1fcd480d233ec196ebd10b6cc9f7b269834555895637fefe5877b"
    sha256 cellar: :any,                 sonoma:        "d29be921fd3fb6713964b839ddec607bb260fbdb1b9ec3dd02e31ee74d2004d8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ae7dfd9797671710954aa83e28a1ae549c0da980d86e50c06636cc5d64c3412f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b0dc356cfcf89bb83e9fc2fb7b250c8dc0449bafa02dea57cf365ae69ee34382"
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
        url "https://static.rust-lang.org/dist/2025-10-30/rustc-1.91.0-aarch64-apple-darwin.tar.xz", using: :nounzip
        sha256 "a68e3ada151e6eee10374529161d35dc26e8a185bddb14eabe6133f37144e02f"
      end
      on_intel do
        url "https://static.rust-lang.org/dist/2025-10-30/rustc-1.91.0-x86_64-apple-darwin.tar.xz", using: :nounzip
        sha256 "de5afa548daca986e428728cf66e16cb5a9560e6bda2f61d0e55874b74811af5"
      end
    end

    on_linux do
      on_arm do
        url "https://static.rust-lang.org/dist/2025-10-30/rustc-1.91.0-aarch64-unknown-linux-gnu.tar.xz", using: :nounzip
        sha256 "f3ea3c964b7f3b884337f2d411764032bbd1722d7f55592a547cbb29afd87c03"
      end
      on_intel do
        url "https://static.rust-lang.org/dist/2025-10-30/rustc-1.91.0-x86_64-unknown-linux-gnu.tar.xz", using: :nounzip
        sha256 "a7169e8cb6174af2f45717703370363d8de82ce55f6ccba185893045b9370874"
      end
    end
  end

  # From https://github.com/rust-lang/rust/blob/#{version}/src/stage0
  resource "cargo-bootstrap" do
    on_macos do
      on_arm do
        url "https://static.rust-lang.org/dist/2025-10-30/cargo-1.91.0-aarch64-apple-darwin.tar.xz", using: :nounzip
        sha256 "2f50ee5fe07c2a8df9f67726aad0fd30d343ba52485f76d57c4d0ca1113b2343"
      end
      on_intel do
        url "https://static.rust-lang.org/dist/2025-10-30/cargo-1.91.0-x86_64-apple-darwin.tar.xz", using: :nounzip
        sha256 "f8935229479bb5d76378e768a4cbf868daa1264fd2ea7635b353fe0d93c0cda8"
      end
    end

    on_linux do
      on_arm do
        url "https://static.rust-lang.org/dist/2025-10-30/cargo-1.91.0-aarch64-unknown-linux-gnu.tar.xz", using: :nounzip
        sha256 "003d7008219ca0d225ad1dfa301f7c079b123499430ee0780c85782e0878eeff"
      end
      on_intel do
        url "https://static.rust-lang.org/dist/2025-10-30/cargo-1.91.0-x86_64-unknown-linux-gnu.tar.xz", using: :nounzip
        sha256 "7103c03fb8abe85b23307005a9dfe4f01c826a89945d84b96fa2d03fd4d2d138"
      end
    end
  end

  # From https://github.com/rust-lang/rust/blob/#{version}/src/stage0
  resource "rust-std-bootstrap" do
    on_macos do
      on_arm do
        url "https://static.rust-lang.org/dist/2025-10-30/rust-std-1.91.0-aarch64-apple-darwin.tar.xz", using: :nounzip
        sha256 "d2e1cbce8dda7a9f16df1393d003f6eb145b3b152a883a8791db326ebc03b549"
      end
      on_intel do
        url "https://static.rust-lang.org/dist/2025-10-30/rust-std-1.91.0-x86_64-apple-darwin.tar.xz", using: :nounzip
        sha256 "fd490b52577ac1ba1aa3e420e9bee0099e3c2fbba613b8c3d9b10553cbd0c6ff"
      end
    end

    on_linux do
      on_arm do
        url "https://static.rust-lang.org/dist/2025-10-30/rust-std-1.91.0-aarch64-unknown-linux-gnu.tar.xz", using: :nounzip
        sha256 "ff23dc81f796d64e34e866a44fd0bcae726e34014835369b8f9393a544167eca"
      end
      on_intel do
        url "https://static.rust-lang.org/dist/2025-10-30/rust-std-1.91.0-x86_64-unknown-linux-gnu.tar.xz", using: :nounzip
        sha256 "89e6520b16c12b43526440298d2da0dcb70747c5cc2d0b8e47d39b5da9aeef49"
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
