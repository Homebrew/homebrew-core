class Rust < Formula
  desc "Safe, concurrent, practical language"
  homepage "https://www.rust-lang.org/"
  license any_of: ["Apache-2.0", "MIT"]

  stable do
    url "https://static.rust-lang.org/dist/rustc-1.87.0-src.tar.gz"
    sha256 "149bb9fd29be592da4e87900fc68f0629a37bf6850b46339dd44434c04fd8e76"

    # From https://github.com/rust-lang/rust/tree/#{version}/src/tools
    resource "cargo" do
      url "https://github.com/rust-lang/cargo/archive/refs/tags/0.88.0.tar.gz"
      sha256 "ab1d7b418c937862a1b730be478832b02ce1d656ad02f363a99744bcbc55af22"
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "21cc7fb6dbd8405bd6d4bdcee865b4fdb48d92a430a0fe43829ff7fcb9723a39"
    sha256 cellar: :any,                 arm64_sonoma:  "f077fc9fa21b1e44b9a47dc7943cc060805a53c9f963df27c9194c2c7befdd47"
    sha256 cellar: :any,                 arm64_ventura: "8595c28593cd1c69012e7955d9c089c77098e9b683e115001af69c1571347b4b"
    sha256 cellar: :any,                 sonoma:        "75d85e9632fd58235d33b757176d0dba3818ff42788fbb88e462dd56d91f54a1"
    sha256 cellar: :any,                 ventura:       "5c52053fab470f5e734baa816d9596904237fb98b4aca77128ab29e380de0350"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "282e9493133f3fd7c5fde9529fa823f2ccc23a81cf12ac0c99c29bc8e36effcd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d55e4d97132485b6bacf92aaa34f9db89839fd2158e87c5f3248c81d7bab5574"
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
  uses_from_macos "zlib"

  link_overwrite "etc/bash_completion.d/cargo"
  # These used to belong in `rustfmt`.
  link_overwrite "bin/cargo-fmt", "bin/git-rustfmt", "bin/rustfmt", "bin/rustfmt-*"

  # From https://github.com/rust-lang/rust/blob/#{version}/src/stage0
  resource "rustc-bootstrap" do
    on_macos do
      on_arm do
        url "https://static.rust-lang.org/dist/2025-04-03/rustc-1.86.0-aarch64-apple-darwin.tar.xz", using: :nounzip
        sha256 "23b8f52102249a47ab5bc859d54c9a3cb588a3259ba3f00f557d50edeca4fde9"
      end
      on_intel do
        url "https://static.rust-lang.org/dist/2025-04-03/rustc-1.86.0-x86_64-apple-darwin.tar.xz", using: :nounzip
        sha256 "42b76253626febb7912541a30d3379f463dec89581aad4cb72c6c04fb5a71dc5"
      end
    end

    on_linux do
      on_arm do
        url "https://static.rust-lang.org/dist/2025-04-03/rustc-1.86.0-aarch64-unknown-linux-gnu.tar.xz", using: :nounzip
        sha256 "ccece9e59546d2e6ff3fc3b8f4b033aab21631c271eefbe814b3cbace6628c6e"
      end
      on_intel do
        url "https://static.rust-lang.org/dist/2025-04-03/rustc-1.86.0-x86_64-unknown-linux-gnu.tar.xz", using: :nounzip
        sha256 "4438b809ce4a083af31ed17aeeedcc8fc60ccffc0625bef1926620751b6989d7"
      end
    end
  end

  # From https://github.com/rust-lang/rust/blob/#{version}/src/stage0
  resource "cargo-bootstrap" do
    on_macos do
      on_arm do
        url "https://static.rust-lang.org/dist/2025-04-03/cargo-1.86.0-aarch64-apple-darwin.tar.xz", using: :nounzip
        sha256 "3cb13873d48c3e1e4cc684d42c245226a11fba52af6b047c3346ed654e7a05c0"
      end
      on_intel do
        url "https://static.rust-lang.org/dist/2025-04-03/cargo-1.86.0-x86_64-apple-darwin.tar.xz", using: :nounzip
        sha256 "af163eb02d1a178044d1b4f2375960efd47130f795f6e33d09e345454bb26f4e"
      end
    end

    on_linux do
      on_arm do
        url "https://static.rust-lang.org/dist/2025-04-03/cargo-1.86.0-aarch64-unknown-linux-gnu.tar.xz", using: :nounzip
        sha256 "37156542b702e8b4ffd1c5c75017632582343e93ca378285cdc92196c85c77e3"
      end
      on_intel do
        url "https://static.rust-lang.org/dist/2025-04-03/cargo-1.86.0-x86_64-unknown-linux-gnu.tar.xz", using: :nounzip
        sha256 "c5c1590f7e9246ad9f4f97cfe26ffa92707b52a769726596a9ef81565ebd908b"
      end
    end
  end

  # From https://github.com/rust-lang/rust/blob/#{version}/src/stage0
  resource "rust-std-bootstrap" do
    on_macos do
      on_arm do
        url "https://static.rust-lang.org/dist/2025-04-03/rust-std-1.86.0-aarch64-apple-darwin.tar.xz", using: :nounzip
        sha256 "0fb121fb3b8fa9027d79ff598500a7e5cd086ddbc3557482ed3fdda00832c61b"
      end
      on_intel do
        url "https://static.rust-lang.org/dist/2025-04-03/rust-std-1.86.0-x86_64-apple-darwin.tar.xz", using: :nounzip
        sha256 "3b1140d54870a080080e84700143f4a342fbd02a410a319b05d9c02e7dcf44cc"
      end
    end

    on_linux do
      on_arm do
        url "https://static.rust-lang.org/dist/2025-04-03/rust-std-1.86.0-aarch64-unknown-linux-gnu.tar.xz", using: :nounzip
        sha256 "176129577a5d560bbd94bcd2d24c0228bb495b73219df02556b4e4b4f0815bf7"
      end
      on_intel do
        url "https://static.rust-lang.org/dist/2025-04-03/rust-std-1.86.0-x86_64-unknown-linux-gnu.tar.xz", using: :nounzip
        sha256 "67be7184ea388d8ce0feaf7fdea46f1775cfc2970930264343b3089898501d37"
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
