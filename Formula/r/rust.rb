class Rust < Formula
  desc "Safe, concurrent, practical language"
  homepage "https://www.rust-lang.org/"
  license any_of: ["Apache-2.0", "MIT"]
  compatibility_version 1
  head "https://github.com/rust-lang/rust.git", branch: "main"

  stable do
    url "https://static.rust-lang.org/dist/rustc-1.100.0-src.tar.gz"
    sha256 "e8904548563117043c24a67c4967119b7c9ed304821988283e7681122ceec98b"

    # From https://github.com/rust-lang/rust/blob/#{version}/src/stage0
    # HEAD does not use these as it needs a nightly rust
    resource "rustc-bootstrap" do
      on_macos do
        on_arm do
          url "https://static.rust-lang.org/dist/2026-10-01/rustc-1.99.0-aarch64-apple-darwin.tar.xz", using: :nounzip
          sha256 "334a66714ca316d71bbe5efe44f71762d0b276cea73be2987374693a837f7450"
        end
        on_intel do
          url "https://static.rust-lang.org/dist/2026-10-01/rustc-1.99.0-x86_64-apple-darwin.tar.xz", using: :nounzip
          sha256 "7460910254f059b49b99ee3ddbcf7197d16b9505b59c166e14a1465ee323a81d"
        end
      end
      on_linux do
        on_arm do
          url "https://static.rust-lang.org/dist/2026-10-01/rustc-1.99.0-aarch64-unknown-linux-gnu.tar.xz", using: :nounzip
          sha256 "89c0f1a3a44df63c95e5d5f2ba093d0a12c5f5f57f8635f8a7a0ce50cf86600e"
        end
        on_intel do
          url "https://static.rust-lang.org/dist/2026-10-01/rustc-1.99.0-x86_64-unknown-linux-gnu.tar.xz", using: :nounzip
          sha256 "77171ba2a0345fdf2abc4fedda55d6de078dae7a68527c28be8c77dcc9604bd5"
        end
      end
    end

    # From https://github.com/rust-lang/rust/blob/#{version}/src/stage0
    resource "cargo-bootstrap" do
      on_macos do
        on_arm do
          url "https://static.rust-lang.org/dist/2026-10-01/cargo-1.99.0-aarch64-apple-darwin.tar.xz", using: :nounzip
          sha256 "76abff0ad79a10a3152dff640ea0d8b3c37637d9300bf55da41b95c3ddc069c1"
        end
        on_intel do
          url "https://static.rust-lang.org/dist/2026-10-01/cargo-1.99.0-x86_64-apple-darwin.tar.xz", using: :nounzip
          sha256 "939b71952afd63ae73bc00f3517c19f0dd7ac54884b5fac16a813ee50985d14d"
        end
      end
      on_linux do
        on_arm do
          url "https://static.rust-lang.org/dist/2026-10-01/cargo-1.99.0-aarch64-unknown-linux-gnu.tar.xz", using: :nounzip
          sha256 "113229fcc16cc1ba004923a4cc275fbf3281dafaaf8b97269f9c00189d497fd4"
        end
        on_intel do
          url "https://static.rust-lang.org/dist/2026-10-01/cargo-1.99.0-x86_64-unknown-linux-gnu.tar.xz", using: :nounzip
          sha256 "d7674918d28093097614cd9728b6ca60db9ea3038f640f0bd1e9a4188c7568ce"
        end
      end
    end

    # From https://github.com/rust-lang/rust/blob/#{version}/src/stage0
    resource "rust-std-bootstrap" do
      on_macos do
        on_arm do
          url "https://static.rust-lang.org/dist/2026-10-01/rust-std-1.99.0-aarch64-apple-darwin.tar.xz", using: :nounzip
          sha256 "a7c6de8aa21e7c31163a7656295b321bb85f5dce55ed8ea95ac9ac561202bb5b"
        end
        on_intel do
          url "https://static.rust-lang.org/dist/2026-10-01/rust-std-1.99.0-x86_64-apple-darwin.tar.xz", using: :nounzip
          sha256 "18ee81961a73c3ae966ecb1e8f6096438c90aeefece8856201a6ecc17f5bc850"
        end
      end
      on_linux do
        on_arm do
          url "https://static.rust-lang.org/dist/2026-10-01/rust-std-1.99.0-aarch64-unknown-linux-gnu.tar.xz", using: :nounzip
          sha256 "1cf7e2ef58ed1cfa6f1adea18e155cbf254c1951f39e5f5e3376879f55fd64a4"
        end
        on_intel do
          url "https://static.rust-lang.org/dist/2026-10-01/rust-std-1.99.0-x86_64-unknown-linux-gnu.tar.xz", using: :nounzip
          sha256 "3e58dff2d0b72196b5ea4e90536e174d400de88564a52694686b81e091169933"
        end
      end
    end
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "ad99261670bcdffa5ef4518662eaffecb4bb07e20c265e24ace2f7239366b6d5"
    sha256 cellar: :any, arm64_tahoe:       "3e8f3b4af11744d0120a5759ea9e4b2ebd387549e59c77e70cc75d132aa04dad"
    sha256 cellar: :any, arm64_sequoia:     "f64776767e36296e228aa92c2badf6ab1c2a434d64364cbdc36871da114b3f7a"
    sha256 cellar: :any, arm64_linux:       "60bfac4b423bdb48812bac2e0718657f7b9db49021a4a8689de71db8dcc21f84"
    sha256 cellar: :any, x86_64_linux:      "4e57acd710d4a84dd72812af61f4e2ee618c60dec758dc2b7b73abb0304f86a4"
  end

  depends_on "libgit2"
  depends_on "libssh2"
  depends_on "llvm"
  depends_on "openssl@4"
  depends_on "pkgconf"
  depends_on "sqlite"

  uses_from_macos "python" => :build
  uses_from_macos "curl"

  # Required by Rust, see https://github.com/rust-lang/rust/issues/39870
  preserve_rpath

  link_overwrite "etc/bash_completion.d/cargo"
  # These used to belong in `rustfmt`.
  link_overwrite "bin/cargo-fmt", "bin/git-rustfmt", "bin/rustfmt", "bin/rustfmt-*"

  def llvm = deps.map(&:name).find { |dep| dep.match?(/^llvm(@\d+)?$/) }

  def openssl = deps.map(&:name).find { |dep| dep.start_with?("openssl@") }

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    # https://docs.rs/openssl/latest/openssl/#manual
    ENV["OPENSSL_DIR"] = formula_opt_prefix(openssl)

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
      --llvm-root=#{formula_opt_prefix(llvm)}
      --enable-llvm-link-shared
      --enable-profiler
      --enable-vendor
      --disable-cargo-native-static
      --disable-docs
      --disable-lld
      --release-channel=#{build.head? ? "nightly" : "stable"}
      --release-description=#{tap.user}
      --set=build.allocator=jemalloc
    ]
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
    llvm_objcopy = formula_opt_bin(llvm)/"llvm-objcopy"
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
        formula_opt_lib(openssl)/shared_library("libssl"),
      ],
    }
    expected_linkage[bin/"cargo"] << if OS.mac?
      formula_opt_lib(openssl)/shared_library("libcrypto")
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
