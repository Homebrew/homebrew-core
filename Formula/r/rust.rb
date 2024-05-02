class Rust < Formula
  desc "Safe, concurrent, practical language"
  homepage "https://www.rust-lang.org/"
  license any_of: ["Apache-2.0", "MIT"]
  revision 1

  stable do
    # TODO: On 1.78.0 release, switch to `llvm` 18.
    url "https://static.rust-lang.org/dist/rustc-1.77.2-src.tar.gz"
    sha256 "c61457ef8f596638fddbc7716778b2f6b99ff12513a3b0f13994c3bc521638c3"

    # From https://github.com/rust-lang/rust/tree/#{version}/src/tools
    resource "cargo" do
      url "https://github.com/rust-lang/cargo/archive/refs/tags/0.78.1.tar.gz"
      sha256 "0283fecebb6d3cbd111688eb0359edaf6676f4b2829201a8afe5a0e3afdb4b48"
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "9a4e56bd545f326e4874d4c56e3c964b49c0b9baeca1f28eac35c1660983291c"
    sha256 cellar: :any,                 arm64_ventura:  "fc47b1c54ecfef8fd2557c3af5cb7431fdb8b85088156e7a70b2c0662fb113fd"
    sha256 cellar: :any,                 arm64_monterey: "5ea95ebfa3b58cdc1f2e4d67a7235a6dda07d42deb4ff708cc9b040073061a16"
    sha256 cellar: :any,                 sonoma:         "b6bca9c71a13b195d64f7349d6c48fa6a6a013e4d7662f0c9a1df180f7733d2c"
    sha256 cellar: :any,                 ventura:        "d3b56b1500b8bc38d5e4d494549522bc2bff4acd5374f401d8ee89dec0f23589"
    sha256 cellar: :any,                 monterey:       "4e3bae10e6e7ea3c3bca94b97347bf3c449ffd5028f3a1ac211158564395454c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "af09fa54543d88f00167db297543aa6a0b5bca3ddd82f32bcd1b3bae19a6e98c"
  end

  head do
    url "https://github.com/rust-lang/rust.git", branch: "master"

    resource "cargo" do
      url "https://github.com/rust-lang/cargo.git", branch: "master"
    end
  end

  depends_on "libgit2"
  depends_on "libssh2"
  depends_on "llvm@17"
  depends_on macos: :sierra
  depends_on "openssl@3"
  depends_on "pkg-config"

  uses_from_macos "python" => :build
  uses_from_macos "curl"
  uses_from_macos "zlib"

  # From https://github.com/rust-lang/rust/blob/#{version}/src/stage0.json
  resource "cargobootstrap" do
    on_macos do
      on_arm do
        url "https://static.rust-lang.org/dist/2024-02-08/cargo-1.76.0-aarch64-apple-darwin.tar.xz"
        sha256 "c963d3bf8f07077b0c87922e53ebb8999c601848def13d6f60a7a102dfa2a8a5"
      end
      on_intel do
        url "https://static.rust-lang.org/dist/2024-02-08/cargo-1.76.0-x86_64-apple-darwin.tar.xz"
        sha256 "c69b9e1167d8c67e46b6c933417af09fd8e26e2ee14c04aadad097977b3cd6a3"
      end
    end

    on_linux do
      on_arm do
        url "https://static.rust-lang.org/dist/2024-02-08/cargo-1.76.0-aarch64-unknown-linux-gnu.tar.xz"
        sha256 "d0c54d824e64b7313a974409541ca3a157b3ed7299865786bd0c440b0e073091"
      end
      on_intel do
        url "https://static.rust-lang.org/dist/2024-02-08/cargo-1.76.0-x86_64-unknown-linux-gnu.tar.xz"
        sha256 "30ec0ad9fca443ec12c544f9ce448dacdde411a45b9042961938b650e918ccfb"
      end
    end
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

    resource("cargobootstrap").stage do
      system "./install.sh", "--prefix=#{buildpath}/cargobootstrap"
    end
    ENV.prepend_path "PATH", buildpath/"cargobootstrap/bin"

    cargo_src_path = buildpath/"src/tools/cargo"
    cargo_src_path.rmtree
    resource("cargo").stage cargo_src_path
    if OS.mac?
      inreplace cargo_src_path/"Cargo.toml",
                /^curl\s*=\s*"(.+)"$/,
                'curl = { version = "\\1", features = ["force-system-lib-on-osx"] }'
    end

    # rustfmt and rust-analyzer are available in their own formulae.
    tools = %w[
      analysis
      cargo
      clippy
      rustdoc
      rust-analyzer-proc-macro-srv
      rust-demangler
      src
    ]
    args = %W[
      --prefix=#{prefix}
      --sysconfdir=#{etc}
      --tools=#{tools.join(",")}
      --llvm-root=#{Formula["llvm@17"].opt_prefix}
      --enable-llvm-link-shared
      --enable-vendor
      --disable-cargo-native-static
      --enable-profiler
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

    (lib/"rustlib/src/rust").install "library"
    rm_f [
      bin.glob("*.old"),
      lib/"rustlib/install.log",
      lib/"rustlib/uninstall.sh",
      (lib/"rustlib").glob("manifest-*"),
    ]
  end

  def post_install
    Dir["#{lib}/rustlib/**/*.dylib"].each do |dylib|
      chmod 0664, dylib
      MachO::Tools.change_dylib_id(dylib, "@rpath/#{File.basename(dylib)}")
      MachO.codesign!(dylib) if Hardware::CPU.arm?
      chmod 0444, dylib
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
