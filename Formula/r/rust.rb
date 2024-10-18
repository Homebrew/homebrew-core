class Rust < Formula
  desc "Safe, concurrent, practical language"
  homepage "https://www.rust-lang.org/"
  license any_of: ["Apache-2.0", "MIT"]

  stable do
    url "https://static.rust-lang.org/dist/rustc-1.82.0-src.tar.gz"
    sha256 "7c53f4509eda184e174efa6ba7d5eeb586585686ce8edefc781a2b11a7cf512a"

    # From https://github.com/rust-lang/rust/tree/#{version}/src/tools
    resource "cargo" do
      url "https://github.com/rust-lang/cargo/archive/refs/tags/0.83.0.tar.gz"
      sha256 "53fbf5eb9d0c42ce184bd1b170606db7c878e7ef07ed3b513a67e62e14ca4661"
    end
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "5ac9af77ca0af21928aea2c4ff945b4c2641cf3cd6fe5a05f900407c022b67b5"
    sha256 cellar: :any,                 arm64_sonoma:  "ee7e4b14245fdc2cc0eb624e32dd19cd90c68a13fd0ce8880dc9d227f26a0250"
    sha256 cellar: :any,                 arm64_ventura: "7c44e804a2d41c2367420779c3abe4b07bfdd369372d92115f63d5d41a25b52b"
    sha256 cellar: :any,                 sonoma:        "61ca738cfd88cd304a4983148a74e6e06cc076842b1bb8625e8b7022362249f2"
    sha256 cellar: :any,                 ventura:       "764f9261722fb7759009d0a2a294d191eda51facae1be7721f3e028856fe9f13"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c9226705d4c61a4fd96a004db47492db39a71e78cc34c8b1eb6c02aef25e22a1"
  end

  head do
    url "https://github.com/rust-lang/rust.git", branch: "master"

    resource "cargo" do
      url "https://github.com/rust-lang/cargo.git", branch: "master"
    end
  end

  depends_on "libgit2"
  depends_on "libssh2"
  depends_on "llvm"
  depends_on macos: :sierra
  depends_on "openssl@3"
  depends_on "pkg-config"
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
        url "https://static.rust-lang.org/dist/2024-09-05/rustc-1.81.0-aarch64-apple-darwin.tar.xz", using: :nounzip
        sha256 "bed00f549a08030b232ad811728e3a5d7239e2e53b667df9cfb11eabf87f2cf3"
      end
      on_intel do
        url "https://static.rust-lang.org/dist/2024-09-05/rustc-1.81.0-x86_64-apple-darwin.tar.xz", using: :nounzip
        sha256 "2313aa8a68b514e6e337bb97e933cb25a5cbb48506980da4eeaa04394e595aad"
      end
    end

    on_linux do
      on_arm do
        url "https://static.rust-lang.org/dist/2024-09-05/rustc-1.81.0-aarch64-unknown-linux-gnu.tar.xz", using: :nounzip
        sha256 "301f651f38f8c52ebaad0ac7eb211a5ea25c3b690686d1c265febeee62d2c6fc"
      end
      on_intel do
        url "https://static.rust-lang.org/dist/2024-09-05/rustc-1.81.0-x86_64-unknown-linux-gnu.tar.xz", using: :nounzip
        sha256 "988a4e4cdecebe4f4a0c52ec4ade5a5bfc58d6958969f5b1e8aac033bda2613e"
      end
    end
  end

  # From https://github.com/rust-lang/rust/blob/#{version}/src/stage0
  resource "cargo-bootstrap" do
    on_macos do
      on_arm do
        url "https://static.rust-lang.org/dist/2024-09-05/cargo-1.81.0-aarch64-apple-darwin.tar.xz", using: :nounzip
        sha256 "cc826e6592016db7a5750a97051b71b48aca2d79f146daf08e953d56000ae43d"
      end
      on_intel do
        url "https://static.rust-lang.org/dist/2024-09-05/cargo-1.81.0-x86_64-apple-darwin.tar.xz", using: :nounzip
        sha256 "01a98d95e71025b8c52fdf8bbbe32a2d2739a5861301a99ec889994e3a512292"
      end
    end

    on_linux do
      on_arm do
        url "https://static.rust-lang.org/dist/2024-09-05/cargo-1.81.0-aarch64-unknown-linux-gnu.tar.xz", using: :nounzip
        sha256 "76f8927e4923c26c51b60ef99a29f3609843b3a2730f0bdf2ea6958626f11b11"
      end
      on_intel do
        url "https://static.rust-lang.org/dist/2024-09-05/cargo-1.81.0-x86_64-unknown-linux-gnu.tar.xz", using: :nounzip
        sha256 "c50ee4b1ae8695461930e36d5465dddb7c7a0e0f0aa6cbd60de120b17c38b841"
      end
    end
  end

  # From https://github.com/rust-lang/rust/blob/#{version}/src/stage0
  resource "rust-std-bootstrap" do
    on_macos do
      on_arm do
        url "https://static.rust-lang.org/dist/2024-09-05/rust-std-1.81.0-aarch64-apple-darwin.tar.xz", using: :nounzip
        sha256 "2dba5210a79617a9240570c1f7fcc24912a2c96689a3159324727e5a516c6326"
      end
      on_intel do
        url "https://static.rust-lang.org/dist/2024-09-05/rust-std-1.81.0-x86_64-apple-darwin.tar.xz", using: :nounzip
        sha256 "8319664a0b39ac47d9b52fce0f45bc9c37b06669ab4f1204a709fb0f2a5a03c3"
      end
    end

    on_linux do
      on_arm do
        url "https://static.rust-lang.org/dist/2024-09-05/rust-std-1.81.0-aarch64-unknown-linux-gnu.tar.xz", using: :nounzip
        sha256 "85567f037cee338f8ec8f9b6287a7f200d221658a996cba254abc91606ece6f4"
      end
      on_intel do
        url "https://static.rust-lang.org/dist/2024-09-05/rust-std-1.81.0-x86_64-unknown-linux-gnu.tar.xz", using: :nounzip
        sha256 "6ddf80f254e8eea9956308ba89fd68e1ac7885853df9239b07bbc9f047b7562f"
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
  end

  def post_install
    lib.glob("rustlib/**/*.dylib") do |dylib|
      chmod 0664, dylib
      MachO::Tools.change_dylib_id(dylib, "@rpath/#{File.basename(dylib)}")
      MachO.codesign!(dylib) if Hardware::CPU.arm?
      chmod 0444, dylib
    end
    return unless OS.mac?

    # Symlink our LLVM here to make sure the adjacent bin/rust-lld can find it.
    # Needs to be done in `postinstall` to avoid having `change_dylib_id` done on it.
    lib.glob("rustlib/*/lib") do |dir|
      # Use `ln_sf` instead of `install_symlink` to avoid resolving this into a Cellar path.
      ln_sf llvm.opt_lib/shared_library("libLLVM"), dir
    end
  end

  def check_binary_linkage(binary, library)
    binary.dynamically_linked_libraries.any? do |dll|
      next false unless dll.start_with?(HOMEBREW_PREFIX.to_s)

      File.realpath(dll) == File.realpath(library)
    end
  end

  test do
    system bin/"rustdoc", "-h"
    (testpath/"hello.rs").write <<~EOS
      fn main() {
        println!("Hello World!");
      }
    EOS
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
        next if check_binary_linkage(binary, dylib)

        missing_linkage << "#{binary} => #{dylib}"
      end
    end
    assert missing_linkage.empty?, "Missing linkage: #{missing_linkage.join(", ")}"
  end
end
