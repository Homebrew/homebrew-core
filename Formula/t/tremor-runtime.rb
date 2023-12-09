class TremorRuntime < Formula
  desc "Early-stage event processing system for unstructured data"
  homepage "https://www.tremor.rs/"
  license "Apache-2.0"

  stable do
    url "https://github.com/tremor-rs/tremor-runtime/archive/refs/tags/v0.12.4.tar.gz"
    sha256 "91cbe0ca5c4adda14b8456652dfaa148df9878e09dd65ac6988bb781e3df52af"

    # Use `llvm@15` to work around build failure with Clang 16 described in
    # https://github.com/rust-lang/rust-bindgen/issues/2312.
    # TODO: Switch back to `uses_from_macos "llvm" => :build` when `bindgen` is
    # updated to 0.62.0 or newer. There is a check in the `install` method.
    on_system :linux, macos: :sonoma_or_newer do
      depends_on "llvm@15" => :build
    end

    # Fix invalid usage of `macro_export`.
    # Remove on next release.
    patch do
      url "https://github.com/tremor-rs/tremor-runtime/commit/986fae5cf1022790e60175125b848dc84f67214f.patch?full_index=1"
      sha256 "ff772097264185213cbea09addbcdacc017eda4f90c97d0dad36b0156e3e9dbc"
    end

    # Backport part of commit to build with Rust 1.74
    # Ref: https://github.com/tremor-rs/tremor-runtime/commit/e293c7fef032904ba4555727ff51a3148efe2715
    patch :DATA
  end

  bottle do
    rebuild 2
    sha256 cellar: :any,                 arm64_ventura:  "efa5826b0b470f692379f07d5d1303ceb0fbf1dd8d5062185042461bcd390a71"
    sha256 cellar: :any,                 arm64_monterey: "4f373f2849cdb89dedf4edd77ba6742ecd4963cfcc104227ac54485822befe69"
    sha256 cellar: :any,                 arm64_big_sur:  "37a3edd0351331d3bdc1bebe3337cd37000cff71819d3345a748613a93cedb4a"
    sha256 cellar: :any,                 ventura:        "48cf6ebc8f669c2e4e888483b1bf798c736335efc1d94929238eb52b9b912fb9"
    sha256 cellar: :any,                 monterey:       "7764dfa50f3ceaa361799ea9f576e77f9d809a9bbc541688f331e605ade4109d"
    sha256 cellar: :any,                 big_sur:        "a6ab5749ffcfefc98be00158795203b8b99f17fee2c0c6985ee404082454ffb0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "df88e4137f9eb13a7f8c26324f7e97031335464d8505448131a8c6f1542352ac"
  end

  head do
    url "https://github.com/tremor-rs/tremor-runtime.git", branch: "main"
    uses_from_macos "llvm" => :build
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "librdkafka"
  depends_on "oniguruma"
  depends_on "xz" # for liblzma

  fails_with :gcc do
    version "8"
    cause "gcc 9+ required for c++20"
  end

  def install
    ENV["CARGO_FEATURE_DYNAMIC_LINKING"] = "1" # for librdkafka
    ENV["RUSTONIG_DYNAMIC_LIBONIG"] = "1"
    # Needs SSE4.2 to build `simd-json` dependency
    ENV["HOMEBREW_OPTFLAGS"] = "-march=nehalem" if OS.linux? && Hardware::CPU.intel? && build.bottle?

    if build.stable?
      if version >= "0.13"
        odie "`bindgen` is no longer a dependency with `grok` 2! Please remove " \
             'this check and try switching to `uses_from_macos "llvm" => :build`.'
      end
      # Work around an Xcode 15 linker issue which causes linkage against LLVM's
      # libunwind due to it being present in a library search path.
      ENV.remove "HOMEBREW_LIBRARY_PATHS", Formula["llvm@15"].opt_lib
    end

    inreplace ".cargo/config", "+avx,+avx2,", ""

    system "cargo", "install", *std_cargo_args(path: "tremor-cli")

    generate_completions_from_executable(bin/"tremor", "completions", base_name: "tremor")
    # Bash completions are not compatible with Bash 3 so don't use v1 directory.
    # bash: complete: nosort: invalid option name
    # Issue ref: https://github.com/clap-rs/clap/issues/5190
    (share/"bash-completion/completions").install bash_completion.children

    # main binary
    bin.install "target/release/tremor"

    # stdlib
    (lib/"tremor-script").install (buildpath/"tremor-script/lib").children

    # sample config for service
    (etc/"tremor").install "docker/config/docker.troy" => "main.troy"

    # wrapper
    (bin/"tremor-wrapper").write_env_script (bin/"tremor"), TREMOR_PATH: "#{lib}/tremor-script"
  end

  # demo service
  service do
    run [opt_bin/"tremor-wrapper", "run", etc/"tremor/main.troy"]
    keep_alive true
    working_dir HOMEBREW_PREFIX
    log_path var/"log/tremor.log"
    error_log_path var/"log/tremor_error.log"
  end

  def caveats
    on_intel do
      "#{name} requires at least SSE4.2 CPU instruction support." unless Hardware::CPU.sse4_2?
    end
  end

  test do
    assert_match "tremor #{version}\n", shell_output("#{bin}/tremor --version")

    (testpath/"test.troy").write <<~EOS
      define flow test
      flow
          use tremor::connectors;

          define pipeline capitalize
          into
              out, err, exit
          pipeline
              use std::string;
              use std::time::nanos;
              select string::uppercase(event) from in into out;
              select {"exit": 0, "delay": nanos::from_seconds(1) } from in into exit;
          end;

          define connector file_in from file
              with codec="string", config={"path": "#{testpath}/in.txt", "mode": "read"}
          end;
          define connector file_out from file
              with codec="string", config={"path": "#{testpath}/out.txt", "mode": "truncate"}
          end;

          create pipeline capitalize from capitalize;
          create connector input from file_in;
          create connector output from file_out;
          create connector exit from connectors::exit;

          connect /connector/input to /pipeline/capitalize;
          connect /pipeline/capitalize to /connector/output;
          connect /pipeline/capitalize/exit to /connector/exit;
      end;

      deploy flow test;
    EOS

    (testpath/"in.txt").write("hello")

    system bin/"tremor-wrapper", "run", testpath/"test.troy"

    assert_match(/^HELLO/, (testpath/"out.txt").readlines.first)
  end
end

__END__
diff --git a/tremor-value/src/macros.rs b/tremor-value/src/macros.rs
index da4bdbdeae5f398ca8d58cd5fe48835daaaf037b..5119e9a6ab5c4df88a3540e1e812b5422f0074ce 100644
--- a/tremor-value/src/macros.rs
+++ b/tremor-value/src/macros.rs
@@ -191,11 +191,11 @@ macro_rules! literal_internal {
 
     // Done. Insert all entries from the stack
     (@object $object:ident [@entries $(($value:expr => $($key:tt)+))*] () () ()) => {
-        let len = literal_internal!(@object @count [@entries $(($value:expr => $($key:tt)+))*]);
+        let len = literal_internal!(@object @count [@entries $(($value => $($key)+))*]);
         $object = $crate::Object::with_capacity(len);
         $(
             // ALLOW: this is a macro, we don't care about the return value
-            let _ = $object.insert(($($key)+).into(), $value);
+            $object.insert(($($key)+).into(), $value);
         )*
     };
