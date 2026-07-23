class RustWasm < Formula
  desc "Rust standard library and sysroot for WebAssembly targets"
  homepage "https://www.rust-lang.org/"
  url "https://static.rust-lang.org/dist/rustc-1.97.1-src.tar.gz"
  sha256 "622c2b429c53cbfdc0dd3a51d03554e91cd63ebec1912c1f5709640cdfef1a9d"
  license any_of: ["Apache-2.0", "MIT"]

  livecheck do
    formula "rust"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a43cc53ad6f93181d866add98e107136eea3951b00b7af4715793bc078b3e583"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a43cc53ad6f93181d866add98e107136eea3951b00b7af4715793bc078b3e583"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a43cc53ad6f93181d866add98e107136eea3951b00b7af4715793bc078b3e583"
    sha256 cellar: :any_skip_relocation, sonoma:        "4443a5f831b95873e2a5baf8cf23a91b9718fc9e5e594c165ee6db39bbe917de"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0a2e031c3f008624e9ce1ae96bf39469946e3298b7b1297861a7519dcd086f2c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "36ec7d9e41e07606a99e622cccc8041ae5ac8181b5931563ff54dbbccb4711ac"
  end

  depends_on "wasmtime" => :test
  depends_on "lld"
  depends_on "rust"
  depends_on "wasi-libc"
  depends_on "wasm-component-ld"

  # WebAssembly targets we build `std` for. `wasm32-unknown-unknown` is
  # self-contained; the WASI targets link against `wasi-libc`.
  def wasm_targets
    %w[
      wasm32-unknown-unknown
      wasm32-wasip1
      wasm32-wasip2
    ]
  end

  def install
    # `-Zbuild-std` compiles `std` from `rust`'s bundled source with the
    # installed compiler, so the rlibs match that rustc exactly (no second
    # compiler is built). The flag is unstable, so unlock it on the stable
    # toolchain with RUSTC_BOOTSTRAP, exactly as `cargo -Zbuild-std` users do.
    ENV["RUSTC_BOOTSTRAP"] = "1"

    # `-Zbuild-std` bakes the paths it compiles from into the rlibs' debug and
    # metadata info: `std` out of `rust`'s keg and the crates.io deps out of
    # `buildpath`. Remap both to the virtual `/rustc/<commit>` prefix upstream
    # rustc uses, so the bottled rlibs carry no builder-specific paths.
    # `-Cembed-bitcode=yes` matches rustup's std so dependents can enable LTO.
    sysroot = Utils.safe_popen_read("rustc", "--print", "sysroot").chomp
    commit = Utils.safe_popen_read("rustc", "--version", "--verbose")[/^commit-hash:\s*(\S+)$/, 1]
    rustflags = %W[
      --remap-path-prefix=#{sysroot}/lib/rustlib/src/rust=/rustc/#{commit}
      --remap-path-prefix=#{buildpath}=/rustc/#{commit}
      -Cembed-bitcode=yes
    ]
    ENV.append_to_rustflags rustflags.join(" ")

    # `-Zbuild-std` only builds `std` as a dependency of a crate being
    # compiled; it has no standalone "emit a sysroot" mode. So compile a
    # minimal stub and harvest the `std` rlibs it pulls in (below).
    # `[workspace]` stops cargo from treating the stub as a member of the
    # unpacked rustc source workspace.
    (buildpath/"stub/Cargo.toml").write <<~TOML
      [package]
      name = "rust-wasm-stub"
      version = "0.0.0"
      edition = "2021"

      [lib]
      crate-type = ["lib"]

      [workspace]
    TOML
    (buildpath/"stub/src/lib.rs").write "#![no_std]\n"

    wasm_targets.each do |target|
      system "cargo", "build",
                      "--lib",
                      "--release",
                      "--offline",
                      "--manifest-path", buildpath/"stub/Cargo.toml",
                      "--target-dir", buildpath/"target",
                      "--target", target,
                      "-Zbuild-std=std,panic_abort"

      target_lib = lib/"rustlib"/target/"lib"
      buildpath.glob("target/#{target}/release/deps/*.rlib").each do |rlib|
        # Skip the stub crate itself; keep `std` and all of its dependencies.
        next if rlib.basename.to_s.start_with?("librust_wasm_stub")

        target_lib.install rlib
      end
    end

    # WASI targets link statically against wasi-libc; rustc looks for the crt
    # objects and libc under each target's `self-contained` directory.
    wasi_lib = Formula["wasi-libc"].opt_share/"wasi-sysroot/lib"
    wasi_crt = %w[crt1-command.o crt1-reactor.o libc.a]
    wasm_targets.grep(/wasip/).each do |target|
      self_contained = lib/"rustlib"/target/"lib/self-contained"
      self_contained.mkpath
      wasi_crt.each do |obj|
        ln_s (wasi_lib/target/obj).relative_path_from(self_contained), self_contained
      end
    end

    # Cargo configuration that selects this sysroot and the right wasm linker.
    (pkgshare/"cargo-config.toml").write cargo_config
  end

  # Points cargo at this sysroot per target. `--sysroot` in per-target
  # `rustflags` applies only when compiling for wasm, so host build scripts and
  # proc-macros keep using `rust`'s own sysroot.
  def cargo_config
    <<~TOML
      [target.wasm32-unknown-unknown]
      rustflags = ["--sysroot", "#{HOMEBREW_PREFIX}"]
      linker = "wasm-ld"

      [target.wasm32-wasip1]
      rustflags = ["--sysroot", "#{HOMEBREW_PREFIX}"]
      linker = "wasm-ld"

      [target.wasm32-wasip2]
      rustflags = ["--sysroot", "#{HOMEBREW_PREFIX}"]
    TOML
  end

  def caveats
    example_target = wasm_targets.first
    <<~EOS
      Included targets: #{wasm_targets.join(", ")}

      To cross-compile for, e.g., #{example_target}:
        cargo build --config #{opt_pkgshare}/cargo-config.toml --target #{example_target}
    EOS
  end

  test do
    config = pkgshare/"cargo-config.toml"

    # wasm32-unknown-unknown has no OS or runtime, so just confirm we can link a
    # valid WebAssembly module against the freshly built `core`, driving cargo
    # through the shipped config via `--config` (as the caveats suggest).
    (testpath/"nostd/Cargo.toml").write <<~TOML
      [package]
      name = "nostd"
      version = "0.0.0"
      edition = "2021"

      [lib]
      crate-type = ["cdylib"]

      [profile.release]
      panic = "abort"

      [workspace]
    TOML
    (testpath/"nostd/src/lib.rs").write <<~RUST
      #![no_std]
      #[panic_handler]
      fn panic(_: &core::panic::PanicInfo) -> ! { loop {} }
      #[no_mangle]
      pub extern "C" fn add(a: i32, b: i32) -> i32 { a + b }
    RUST
    cd(testpath/"nostd") do
      system "cargo", "build", "--release", "--offline",
             "--config", config, "--target", "wasm32-unknown-unknown"
    end
    wasm = testpath/"nostd/target/wasm32-unknown-unknown/release/nostd.wasm"
    assert_equal "\x00asm".b, wasm.binread(4)

    # The WASI targets can actually run. Give each project its own
    # `.cargo/config.toml` (target + an env var it prints) and layer ours in via
    # `--config`, with no `--target` on the CLI: a running wasm binary that
    # prints the greeting proves the project config and ours (sysroot + linker)
    # both took effect.
    wasm_targets.grep(/wasip/).each do |target|
      name = target.tr("-", "_")
      system "cargo", "new", "--bin", "--vcs", "none", testpath/name
      (testpath/name/".cargo/config.toml").write <<~TOML
        [build]
        target = "#{target}"

        [env]
        RUST_WASM_GREETING = "hello from #{target}"
      TOML
      # atomic_write clobbers the main.rs that `cargo new` generated.
      (testpath/name/"src/main.rs").atomic_write <<~RUST
        fn main() {
            println!("{}", env!("RUST_WASM_GREETING"));
        }
      RUST
      cd(testpath/name) do
        system "cargo", "build", "--release", "--offline", "--config", config
      end
      module_path = testpath/name/"target"/target/"release/#{name}.wasm"
      assert_equal "hello from #{target}", shell_output("wasmtime run #{module_path}").strip
    end
  end
end
