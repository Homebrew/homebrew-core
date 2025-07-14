class Rust < Formula
  desc "Safe, concurrent, practical language"
  homepage "https://www.rust-lang.org/"
  license any_of: ["Apache-2.0", "MIT"]

  stable do
    url "https://static.rust-lang.org/dist/rustc-1.88.0-src.tar.gz"
    sha256 "3a97544434848ae3d193d1d6bc83d6f24cb85c261ad95f955fde47ec64cfcfbe"

    # From https://github.com/rust-lang/rust/tree/#{version}/src/tools
    resource "cargo" do
      url "https://github.com/rust-lang/cargo/archive/refs/tags/0.89.0.tar.gz"
      sha256 "53bce6e8c8ed046054ecc87514cbfba38cc782589629db792f9b74fd16cf9b37"
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "3c5a5df4bf799b2d391c6cf6a24c0372096c8c1e9545f05ec975656828fd4806"
    sha256 cellar: :any,                 arm64_sonoma:  "ab150fadabc7cc8b7ef2b55aa5985bc4f8bdd4b4a9bf89cafe27e7eedcbef804"
    sha256 cellar: :any,                 arm64_ventura: "7e9f24e72dda5498bfa4cbac3e5e8421e4e348e81109d4b98e921cc4937f76f6"
    sha256 cellar: :any,                 sonoma:        "21d84182258eed27c495e3df874a6a66649c0bcec531f067b8cf5acd2b20b5f7"
    sha256 cellar: :any,                 ventura:       "38c20f0c5524711c506dc1417c68da1263c07be3e1458ec2282cb07aed74a3ba"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b14114399fe5845bdc4539aaad54f0f80c2acf66f12745139490851d575416c1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8baf210a4a8a1efe8b8b1bdb88e226fbba96844a37a54ac97c9b9725f5424f1b"
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
  depends_on "pkgconf"
  depends_on "zstd"

  uses_from_macos "python" => :build
  uses_from_macos "curl"

  link_overwrite "etc/bash_completion.d/cargo"
  # These used to belong in `rustfmt`.
  link_overwrite "bin/cargo-fmt", "bin/git-rustfmt", "bin/rustfmt", "bin/rustfmt-*"

  # From https://github.com/rust-lang/rust/blob/#{version}/src/stage0
  resource "rustc-bootstrap" do
    on_macos do
      on_arm do
        url "https://static.rust-lang.org/dist/2025-05-15/rustc-1.87.0-aarch64-apple-darwin.tar.xz", using: :nounzip
        sha256 "175800bc89cccd8f8ee2f3a4d07bdf98c163030fd5d3dc6d5b23cf4dd0a2a4c3"
      end
      on_intel do
        url "https://static.rust-lang.org/dist/2025-05-15/rustc-1.87.0-x86_64-apple-darwin.tar.xz", using: :nounzip
        sha256 "05e2fefe5afed492f2082f58e7e5bf9e0332cea9dddae5ea243e70283b92b6ce"
      end
    end

    on_linux do
      on_arm do
        url "https://static.rust-lang.org/dist/2025-05-15/rustc-1.87.0-aarch64-unknown-linux-gnu.tar.xz", using: :nounzip
        sha256 "93c59a880632aa1c69e3ffaa1830b5b19c08341ae2cd364bf4e6d13901facfed"
      end
      on_intel do
        url "https://static.rust-lang.org/dist/2025-05-15/rustc-1.87.0-x86_64-unknown-linux-gnu.tar.xz", using: :nounzip
        sha256 "e8395c5c5756253b76107055e093ffbc4431af7b30aeebe72ce2684b9cb53973"
      end
    end
  end

  # From https://github.com/rust-lang/rust/blob/#{version}/src/stage0
  resource "cargo-bootstrap" do
    on_macos do
      on_arm do
        url "https://static.rust-lang.org/dist/2025-05-15/cargo-1.87.0-aarch64-apple-darwin.tar.xz", using: :nounzip
        sha256 "f8d6f554e5ed081de5c3fd23cf2f30f4012013e95fb7a5458a50d8215651fb88"
      end
      on_intel do
        url "https://static.rust-lang.org/dist/2025-05-15/cargo-1.87.0-x86_64-apple-darwin.tar.xz", using: :nounzip
        sha256 "f64c61e5910bd23238cb2bc48174b94b17c281933e1b38159a8f62caf15d4334"
      end
    end

    on_linux do
      on_arm do
        url "https://static.rust-lang.org/dist/2025-05-15/cargo-1.87.0-aarch64-unknown-linux-gnu.tar.xz", using: :nounzip
        sha256 "51e237e7f383840a404a5be721491a8ca4671bf9c14e62566ecadccfcc6e4291"
      end
      on_intel do
        url "https://static.rust-lang.org/dist/2025-05-15/cargo-1.87.0-x86_64-unknown-linux-gnu.tar.xz", using: :nounzip
        sha256 "469d5dc479835adadd728bc3587f8abf1941b3dd71f9865abd3e0783ae662555"
      end
    end
  end

  # From https://github.com/rust-lang/rust/blob/#{version}/src/stage0
  resource "rust-std-bootstrap" do
    on_macos do
      on_arm do
        url "https://static.rust-lang.org/dist/2025-05-15/rust-std-1.87.0-aarch64-apple-darwin.tar.xz", using: :nounzip
        sha256 "6547322b317f18b73695724ff60a7860457df1a646b4a79f89a70a13d0747375"
      end
      on_intel do
        url "https://static.rust-lang.org/dist/2025-05-15/rust-std-1.87.0-x86_64-apple-darwin.tar.xz", using: :nounzip
        sha256 "45ce5785c3595318e2d8738fb07fc8142d52c06e0f6d5d946167ae71bc6acb95"
      end
    end

    on_linux do
      on_arm do
        url "https://static.rust-lang.org/dist/2025-05-15/rust-std-1.87.0-aarch64-unknown-linux-gnu.tar.xz", using: :nounzip
        sha256 "80fab79c1f57b7cd89a1e6379b2196a208352403aa7bd7f674341a172ac0697f"
      end
      on_intel do
        url "https://static.rust-lang.org/dist/2025-05-15/rust-std-1.87.0-x86_64-unknown-linux-gnu.tar.xz", using: :nounzip
        sha256 "1b57253bd32b8b292c965b3a2d992a266763158494cab8555584c09360b90f77"
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
