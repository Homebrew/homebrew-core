class ZvecGrep < Formula
  desc "Agent-friendly hybrid workspace search across code and non-code content"
  homepage "https://github.com/zvec-ai/zvec-grep"
  url "https://github.com/zvec-ai/zvec-grep/archive/refs/tags/v0.3.0.tar.gz"
  sha256 "e1de1fa02e43513abd560a1c8ccc4ed4d82abb78a1b36980ab1550f3fa6b7c39"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "fdf5450fd7e02f90312c70f6740e23c81cc04a1647391c9b137f7bb99300c80f"
    sha256 cellar: :any, arm64_tahoe:       "5bd5d4d2eb01c37f6fe3a44ed2e0526d98da280e746f29cd4f7000edd9bf93b4"
    sha256 cellar: :any, arm64_sequoia:     "4a6f39a575e979f40b9735e0fcceaef3fc0fe9cfa454db38895e4620616558d4"
    sha256 cellar: :any, arm64_linux:       "951d0c0a421e09a377148b84b99a07345aca65a04066d9a57a7afda0fde06688"
    sha256 cellar: :any, x86_64_linux:      "3c2b066dd8b1ede506f3477b1a9ee9b2a800ecfe27967ac021c5d814c2756b2a"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "python@3.15" => :build
  depends_on "rust" => :build
  depends_on "onnxruntime"

  uses_from_macos "llvm" => :build # for libclang

  # Match the native library pinned by zvec-rust 0.8.0; Git fetches its submodules.
  resource "zvec" do
    url "https://github.com/alibaba/zvec.git",
        revision: "8397071d815cd842be2068339e00a94e69f069d1"
    version "8397071d815cd842be2068339e00a94e69f069d1"

    livecheck do
      skip "Pinned to the zvec-rust native ABI"
    end
  end

  resource "simde" do
    url "https://github.com/simd-everywhere/simde/archive/refs/tags/v0.8.2.tar.gz"
    sha256 "ed2a3268658f2f2a9b5367628a85ccd4cf9516460ed8604eed369653d49b25fb"

    livecheck do
      skip "Pinned by Zvec's FastPFOR build"
    end
  end

  # Preserve shared-runtime deployment with Cargo 1.100 without changing the native ABI.
  patch do
    url "https://github.com/zvec-ai/zvec-grep/commit/c68b264d5f7bb3733d28b1b64bfb5ee3c92027ff.patch?full_index=1"
    sha256 "97c77a90a3abf33656507bc9e027c0c4e4848878913a453acbda904ccff1a522"
    type :unofficial
    resolves "https://github.com/zvec-ai/zvec-grep/pull/415"
  end

  allow_network_access! :build

  def install
    native_lib = libexec/"lib"
    # Zvec's architecture-specific kernels are selected at runtime.
    ENV.runtime_cpu_detection
    ENV["LIBCLANG_PATH"] = formula_opt_lib("llvm") if OS.linux?

    resource("simde").stage buildpath/"simde"

    resource("zvec").stage do
      arrow_args = %w[-DBoost_SOURCE=SYSTEM]
      arrow_args << "-DARROW_SIMD_LEVEL=NONE" if Hardware::CPU.intel?
      # Supply FastPFOR's pinned headers without allowing FetchContent downloads.
      args = %W[
        -DCMAKE_POLICY_VERSION_MINIMUM=3.5
        -DFETCHCONTENT_SOURCE_DIR_SIMDE=#{buildpath}/simde
        -DCMAKE_CACHE_ARGS=#{arrow_args.join(";")}
        -DFETCHCONTENT_FULLY_DISCONNECTED=ON
        -DAUTO_DETECT_ARCH=ON
        -DBUILD_C_BINDINGS=ON
        -DBUILD_TOOLS=OFF
        -DCMAKE_BUILD_WITH_INSTALL_RPATH=ON
        -DCMAKE_INSTALL_NAME_DIR=@rpath
      ]
      system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
      system "cmake", "--build", "build", "--target", "zvec_c_api"
      native_lib.install "build/lib/#{shared_library("libzvec_c_api")}"
    end

    # Build the native backend instead of downloading its precompiled SDK.
    ENV["LLAMA_CPP_BUILD_MODE"] = "source"
    # Keep optimized CPU variants and let GGML select a supported one at runtime.
    ENV["LLAMA_BUILD_SHARED_LIBS"] = "1"
    ENV["GGML_BACKEND_DL"] = "ON"
    ENV["GGML_BACKEND_DIR"] = native_lib
    ENV["GGML_CPU_ALL_VARIANTS"] = "ON" if OS.mac? || Hardware::CPU.intel?
    ENV["CMAKE_INSTALL_RPATH"] = rpath
    ENV["CMAKE_BUILD_WITH_INSTALL_RPATH"] = "ON"
    ENV["CMAKE_INSTALL_NAME_DIR"] = "@rpath"
    ENV["CARGO_TARGET_DIR"] = buildpath/"target"
    ENV["ZVEC_AUTO_BUILD"] = "0"
    ENV["ZVEC_LIB_DIR"] = native_lib
    # Use Homebrew's ONNX Runtime instead of the build script's binary download.
    ENV["ORT_DYLIB_PATH"] = formula_opt_lib("onnxruntime")/shared_library("libonnxruntime")
    ort_library = OS.mac? ? "libonnxruntime.1.dylib" : "libonnxruntime.so.1"
    native_lib.install_symlink ENV["ORT_DYLIB_PATH"] => ort_library

    system "cargo", "install", *std_cargo_args(path: "rust/crates/zg", root: libexec)
    native_glob = OS.mac? ? "*.dylib" : "*.so*"
    native_lib.install buildpath.glob("target/release/build/llama-cpp-sys-2*/**/out/lib*/#{native_glob}")
    bin.install_symlink libexec/"bin/zg"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/zg --version")

    (testpath/"f.txt").write("hello unified search\n")
    assert_match "hello unified search", shell_output("#{bin}/zg --rg hello #{testpath} 2>&1")
  end
end
