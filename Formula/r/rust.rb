class Rust < Formula
  desc "Safe, concurrent, practical language"
  homepage "https://www.rust-lang.org/"
  license any_of: ["Apache-2.0", "MIT"]
  revision 1

  stable do
    url "https://static.rust-lang.org/dist/rustc-1.79.0-src.tar.gz"
    sha256 "172ecf3c7d1f9d9fb16cd2a628869782670416ded0129e524a86751f961448c0"

    # From https://github.com/rust-lang/rust/tree/#{version}/src/tools
    resource "cargo" do
      url "https://github.com/rust-lang/cargo/archive/refs/tags/0.80.0.tar.gz"
      sha256 "542efc5daa159e2942d454eb2815247a96589363977429bd473f8cac8a55636e"
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "1fddb77ad4d00483fbfb242d5948818e6a778032fa765383d123d1aeebcbc7c4"
    sha256 cellar: :any,                 arm64_ventura:  "e1ead46d2f13c2947e6e92837065e38b65239fd9c125de2dc7071bbb6c3acd98"
    sha256 cellar: :any,                 arm64_monterey: "fe6d282cc5dffdca8c40a7ff2ca5601648c2af226b32571adff23c0fd22e4623"
    sha256 cellar: :any,                 sonoma:         "5f65642d1eee8232c8a321a2f98caf09a204d2326fbc90ab2a25fe988a9aa7ce"
    sha256 cellar: :any,                 ventura:        "0c2ed3177cb896e4b7d84cbb41a5c833e2fa2b9632e90e639ff9410b5f263454"
    sha256 cellar: :any,                 monterey:       "e9702aff349b3aba8abb6ce985198b1ef1e790c8ad1d0a369bd0dd13598f9969"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c457957e9bf132465398730a92c7050252c811c92f736efc0f8222c499400d14"
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

  uses_from_macos "python" => :build
  uses_from_macos "curl"
  uses_from_macos "zlib"

  # From https://github.com/rust-lang/rust/blob/#{version}/src/stage0.json
  resource "cargobootstrap" do
    on_macos do
      on_arm do
        url "https://static.rust-lang.org/dist/2024-05-02/cargo-1.78.0-aarch64-apple-darwin.tar.xz"
        sha256 "76b9a39eea441b31c6b26cc58ebff7095a64bc60788254c2525e752a1149688d"
      end
      on_intel do
        url "https://static.rust-lang.org/dist/2024-05-02/cargo-1.78.0-x86_64-apple-darwin.tar.xz"
        sha256 "4d4078695265c8489ee5dfefd87d26caa1755a4f46f56f6f07f2b7b7292416c8"
      end
    end

    on_linux do
      on_arm do
        url "https://static.rust-lang.org/dist/2024-05-02/cargo-1.78.0-aarch64-unknown-linux-gnu.tar.xz"
        sha256 "5173f84a07d4cc6b19f27eda7464999c5886232ce8e54bf61b06617635d43fb9"
      end
      on_intel do
        url "https://static.rust-lang.org/dist/2024-05-02/cargo-1.78.0-x86_64-unknown-linux-gnu.tar.xz"
        sha256 "f8aacf7a101eb10dc000b8bf26de90a9d0ce678d02ccf70430ed20dd31ecec6b"
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
      --llvm-root=#{Formula["llvm"].opt_prefix}
      --enable-llvm-link-shared
      --enable-profiler
      --enable-vendor
      --disable-cargo-native-static
      --disable-docs
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
