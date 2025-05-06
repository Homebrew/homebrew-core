class Rust < Formula
  desc "Safe, concurrent, practical language"
  homepage "https://www.rust-lang.org/"
  license any_of: ["Apache-2.0", "MIT"]

  stable do
    url "https://static.rust-lang.org/dist/rustc-1.86.0-src.tar.gz"
    sha256 "022a27286df67900a044d227d9db69d4732ec3d833e4ffc259c4425ed71eed80"

    # From https://github.com/rust-lang/rust/tree/#{version}/src/tools
    resource "cargo" do
      url "https://github.com/rust-lang/cargo/archive/refs/tags/0.87.0.tar.gz"
      sha256 "e37e329434ba84e55b87468372dd597de5e275f6b40acf24574e606c2ac5851b"
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "971ead27d588e6366d860f852475920761575de9d68638a649bdac997fc457c9"
    sha256 cellar: :any,                 arm64_sonoma:  "e611c9aa9342883ad3d71d498d266304243df0f2b962da0d8fffee1143d48a17"
    sha256 cellar: :any,                 arm64_ventura: "0f6bab3da580f6114b6f44140ab7a103d44f408439a054798585c51a12e4c8ae"
    sha256 cellar: :any,                 sonoma:        "ab4a1720e42928aea387ec6c7dba884ce5e6bd4a19f22bb6034028bd9ba7e9c6"
    sha256 cellar: :any,                 ventura:       "60ee18126b2725fb63d63929c9b8c87a49949922a0eec820c1266a2019ebc90c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7d7b438ee1700bffb3b13f28c06ccbeeb59a1170f2694e950af273142ae61fba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f719908dc9b74c754d48d59e606241600aea5e8738e08bd4441819da1fb08aab"
  end

  head do
    url "https://github.com/rust-lang/rust.git", branch: "master"

    resource "cargo" do
      url "https://github.com/rust-lang/cargo.git", branch: "master"
    end
  end

  depends_on "libgit2"
  depends_on "libssh2"
  depends_on "llvm@19" # migrate to LLVM 20 on 1.87.0, https://github.com/rust-lang/rust/pull/135763
  depends_on macos: :sierra
  depends_on "openssl@3"
  depends_on "pkgconf"
  depends_on "zstd"

  uses_from_macos "python" => :build
  uses_from_macos "curl"
  uses_from_macos "zlib"

  link_overwrite "etc/bash_completion.d/cargo"
  # These used to belong in `rustfmt`.
  link_overwrite "bin/cargo-fmt", "bin/git-rustfmt", "bin/rustfmt", "bin/rustfmt-*"

  # From https://github.com/rust-lang/rust/blob/#{version}/src/stage0
  resource "rustc-bootstrap" do
    on_macos do
      on_arm do
        url "https://static.rust-lang.org/dist/2025-02-20/rustc-1.85.0-aarch64-apple-darwin.tar.xz", using: :nounzip
        sha256 "2a03e227b57a49d80b43473b6fa2d56ad661ece0d8ffd81f639cd31600d3823e"
      end
      on_intel do
        url "https://static.rust-lang.org/dist/2025-02-20/rustc-1.85.0-x86_64-apple-darwin.tar.xz", using: :nounzip
        sha256 "19bb6d9608d415779b85100eab92544b0e96d6b84b85b7c3eb4a15df9db1656f"
      end
    end

    on_linux do
      on_arm do
        url "https://static.rust-lang.org/dist/2025-02-20/rustc-1.85.0-aarch64-unknown-linux-gnu.tar.xz", using: :nounzip
        sha256 "e742b768f67303010b002b515f6613c639e69ffcc78cd0857d6fe7989e9880f6"
      end
      on_intel do
        url "https://static.rust-lang.org/dist/2025-02-20/rustc-1.85.0-x86_64-unknown-linux-gnu.tar.xz", using: :nounzip
        sha256 "7436f13797475082cd87aa65547449e01659d6a810b4cd5f8aedc48bb9f89dfb"
      end
    end
  end

  # From https://github.com/rust-lang/rust/blob/#{version}/src/stage0
  resource "cargo-bootstrap" do
    on_macos do
      on_arm do
        url "https://static.rust-lang.org/dist/2025-02-20/cargo-1.85.0-aarch64-apple-darwin.tar.xz", using: :nounzip
        sha256 "d67766fb2e62214b3ee3faf01dcddddcb48e8d0483c2bb3475a16cb96210afed"
      end
      on_intel do
        url "https://static.rust-lang.org/dist/2025-02-20/cargo-1.85.0-x86_64-apple-darwin.tar.xz", using: :nounzip
        sha256 "97cc257fe6a0c547e51b86011f0059a1904ac5e7abdf8f603ed86ec93cc4a9ac"
      end
    end

    on_linux do
      on_arm do
        url "https://static.rust-lang.org/dist/2025-02-20/cargo-1.85.0-aarch64-unknown-linux-gnu.tar.xz", using: :nounzip
        sha256 "cdebe48b066d512d664c13441e8fae2d0f67106c2080aa44289d98b24192b8bc"
      end
      on_intel do
        url "https://static.rust-lang.org/dist/2025-02-20/cargo-1.85.0-x86_64-unknown-linux-gnu.tar.xz", using: :nounzip
        sha256 "0aff33b57b0e0b102d762a2b53042846c1ca346cff4b7bd96b5c03c9e8e51d81"
      end
    end
  end

  # From https://github.com/rust-lang/rust/blob/#{version}/src/stage0
  resource "rust-std-bootstrap" do
    on_macos do
      on_arm do
        url "https://static.rust-lang.org/dist/2025-02-20/rust-std-1.85.0-aarch64-apple-darwin.tar.xz", using: :nounzip
        sha256 "7da1367209de00e3fb315c0e76658e3605ee2559892d29851a3159ae7ea1ddc5"
      end
      on_intel do
        url "https://static.rust-lang.org/dist/2025-02-20/rust-std-1.85.0-x86_64-apple-darwin.tar.xz", using: :nounzip
        sha256 "eefbc63670d44c3825962f7fdf8e00f256ff1f02e22504aba3562e25cea519ec"
      end
    end

    on_linux do
      on_arm do
        url "https://static.rust-lang.org/dist/2025-02-20/rust-std-1.85.0-aarch64-unknown-linux-gnu.tar.xz", using: :nounzip
        sha256 "8af1d793f7820e9ad0ee23247a9123542c3ea23f8857a018651c7788af9bc5b7"
      end
      on_intel do
        url "https://static.rust-lang.org/dist/2025-02-20/rust-std-1.85.0-x86_64-unknown-linux-gnu.tar.xz", using: :nounzip
        sha256 "285e105d25ebdf501341238d4c0594ecdda50ec9078f45095f793a736b1f1ac2"
      end
    end
  end

  def llvm
    Formula["llvm@19"]
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
  end

  def post_install
    lib.glob("rustlib/**/*.dylib") do |dylib|
      chmod 0664, dylib
      MachO::Tools.change_dylib_id(dylib, "@rpath/#{File.basename(dylib)}")
      MachO.codesign!(dylib) if Hardware::CPU.arm?
      chmod 0444, dylib
    end
    return unless OS.mac?

    # Symlink our LLVM here to make sure the adjacent bin/rust-* tools can find it.
    # Needs to be done in `postinstall` to avoid having `change_dylib_id` done on it.
    lib.glob("rustlib/*/lib") do |dir|
      # Use `ln_sf` instead of `install_symlink` to avoid resolving this into a Cellar path.
      ln_sf llvm.opt_lib/shared_library("libLLVM"), dir
    end
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
        Formula["zlib"].opt_lib/shared_library("libz"),
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
