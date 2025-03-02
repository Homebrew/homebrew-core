class Rust < Formula
  desc "Safe, concurrent, practical language"
  homepage "https://www.rust-lang.org/"
  license any_of: ["Apache-2.0", "MIT"]
  revision 1

  stable do
    url "https://static.rust-lang.org/dist/rustc-1.85.0-src.tar.gz"
    sha256 "2f4f3142ffb7c8402139cfa0796e24baaac8b9fd3f96b2deec3b94b4045c6a8a"

    # From https://github.com/rust-lang/rust/tree/#{version}/src/tools
    resource "cargo" do
      url "https://github.com/rust-lang/cargo/archive/refs/tags/0.86.0.tar.gz"
      sha256 "2a63784f9ea81e291b8305dbc84607c5513b9c597ed7e8276973a748036db303"
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "6184b7cc9e0f4b41dd6fd3cccf8420328a71b1868962b27339a6b24b0a5a84e8"
    sha256 cellar: :any,                 arm64_sonoma:  "7e04977b516e4470e111c83208d04c68fdd13659b16795a5807a44cc986ebe60"
    sha256 cellar: :any,                 arm64_ventura: "e8c6edf61b4e6a039ebc9d8cb15719718859036dc4e0264a4706e22f149d0ee5"
    sha256 cellar: :any,                 sonoma:        "946e602f325865d18b7a6ddb2d017aa4d28a9b97d0a685c4818f3bd6a84d5ff6"
    sha256 cellar: :any,                 ventura:       "f5c3a5094a4d10645c2bc7351c88f81230e023ec21d50fb7f9cc2a79d01d1810"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bb16dcc66e595ba48f01f815c8430f7a149550d1426bacf25450564aaa3aedc3"
  end

  head do
    url "https://github.com/rust-lang/rust.git", branch: "master"

    resource "cargo" do
      url "https://github.com/rust-lang/cargo.git", branch: "master"
    end
  end

  depends_on "libgit2@1.8" # upstream issue, https://github.com/rust-lang/cargo/issues/15043
  depends_on "libssh2"
  depends_on "llvm@19"
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
        url "https://static.rust-lang.org/dist/2024-11-28/rustc-1.83.0-aarch64-apple-darwin.tar.xz", using: :nounzip
        sha256 "7a55f65f1ab39f538c31f006e20350362251609af02d2156fc78823419aa2b10"
      end
      on_intel do
        url "https://static.rust-lang.org/dist/2024-11-28/rustc-1.83.0-x86_64-apple-darwin.tar.xz", using: :nounzip
        sha256 "9f951f40a1843298bc068a4f328a6869819a84bf0d55e943166d1b862b99af93"
      end
    end

    on_linux do
      on_arm do
        url "https://static.rust-lang.org/dist/2024-11-28/rustc-1.83.0-aarch64-unknown-linux-gnu.tar.xz", using: :nounzip
        sha256 "aa5d075f9903682e5171f359948717d32911bed8c39e0395042e625652062ea9"
      end
      on_intel do
        url "https://static.rust-lang.org/dist/2024-11-28/rustc-1.83.0-x86_64-unknown-linux-gnu.tar.xz", using: :nounzip
        sha256 "6ec40e0405c8cbed3b786a97d374c144b012fc831b7c22b535f8ecb524f495ad"
      end
    end
  end

  # From https://github.com/rust-lang/rust/blob/#{version}/src/stage0
  resource "cargo-bootstrap" do
    on_macos do
      on_arm do
        url "https://static.rust-lang.org/dist/2024-11-28/cargo-1.83.0-aarch64-apple-darwin.tar.xz", using: :nounzip
        sha256 "42a797429e7f7ac6e6c87c29845fe5face5b694a49b5026c63aed58726181536"
      end
      on_intel do
        url "https://static.rust-lang.org/dist/2024-11-28/cargo-1.83.0-x86_64-apple-darwin.tar.xz", using: :nounzip
        sha256 "ca303bdc840b643aa8905892b14a3ac3fb760e10c7fd87190403ced32412bec3"
      end
    end

    on_linux do
      on_arm do
        url "https://static.rust-lang.org/dist/2024-11-28/cargo-1.83.0-aarch64-unknown-linux-gnu.tar.xz", using: :nounzip
        sha256 "5b96aba48790acfacea60a6643a4f30d7edc13e9189ad36b41bbacdad13d49e1"
      end
      on_intel do
        url "https://static.rust-lang.org/dist/2024-11-28/cargo-1.83.0-x86_64-unknown-linux-gnu.tar.xz", using: :nounzip
        sha256 "de834a4062d9cd200f8e0cdca894c0b98afe26f1396d80765df828880a39b98c"
      end
    end
  end

  # From https://github.com/rust-lang/rust/blob/#{version}/src/stage0
  resource "rust-std-bootstrap" do
    on_macos do
      on_arm do
        url "https://static.rust-lang.org/dist/2024-11-28/rust-std-1.83.0-aarch64-apple-darwin.tar.xz", using: :nounzip
        sha256 "635230a14210e87b82c6f7f0597349c5cb9e5ee3a260c9b049b4b078af72eae1"
      end
      on_intel do
        url "https://static.rust-lang.org/dist/2024-11-28/rust-std-1.83.0-x86_64-apple-darwin.tar.xz", using: :nounzip
        sha256 "9562c98c59c6344f53a4f4c331e34cc88975153b8c25dd8b7a11ce00077ee3cb"
      end
    end

    on_linux do
      on_arm do
        url "https://static.rust-lang.org/dist/2024-11-28/rust-std-1.83.0-aarch64-unknown-linux-gnu.tar.xz", using: :nounzip
        sha256 "8804f673809c5c3db11ba354b5cf9724aed68884771fa32af4b3472127a76028"
      end
      on_intel do
        url "https://static.rust-lang.org/dist/2024-11-28/rust-std-1.83.0-x86_64-unknown-linux-gnu.tar.xz", using: :nounzip
        sha256 "c88fe6cb22f9d2721f26430b6bdd291e562da759e8629e2b4c7eb2c7cad705f2"
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
        Formula["libgit2@1.8"].opt_lib/shared_library("libgit2"),
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
