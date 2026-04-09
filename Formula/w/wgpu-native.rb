class WgpuNative < Formula
  desc "Native WebGPU implementation based on wgpu-core"
  homepage "https://github.com/gfx-rs/wgpu-native"
  url "https://github.com/gfx-rs/wgpu-native.git",
      tag:      "v27.0.4.1",
      revision: "f16f716698899ebfcc3f703722fabd85543318a7"
  license "Apache-2.0"
  head "https://github.com/gfx-rs/wgpu-native.git", branch: "trunk"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "9a234e3632994dcaa1c776e8896e87516207022dd2aa9035bb159ccb0599eece"
    sha256 cellar: :any,                 arm64_sequoia: "cfc78aaac66ed4dd4f82c0af314cef9ffdb8fed8bf46fe8132dd24267b030cb1"
    sha256 cellar: :any,                 arm64_sonoma:  "195917512fa251459d7897407f1586d186ebcfe04ac9e1a06b51f6ad1f1a0edb"
    sha256 cellar: :any,                 sonoma:        "3790c7c2c12472220d9d1e99a6acf0c8bba145ecaaab91d79da124facc2244a1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0828b93c0ff991f5e560f0aa62f41b3ded35fa9ef529c0d053c7fc3ed10e662a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "34b86cec9e81481dfebbf516e2d2244a5b03e85dd2ab8590d12c37af688df523"
  end

  depends_on "rust" => :build
  depends_on "cmake" => :test
  uses_from_macos "llvm" => :build

  on_linux do
    depends_on "mesa" => :test
  end

  def install
    ENV["LIBCLANG_PATH"] = Formula["llvm"].opt_lib.to_s if OS.linux?
    # Not using `cargo install` because wgpu-native doesn't ship binaries
    system "cargo", "build", "--jobs", ENV.make_jobs, "--lib", "--release", "--locked"

    # Manually install artifacts
    include.install "ffi/webgpu-headers/webgpu.h"
    include.install "ffi/wgpu.h"
    (include/"webgpu-headers").install_symlink "../webgpu.h" => "webgpu.h"

    lib.install "target/release/#{shared_library("libwgpu_native")}"
    lib.install "target/release/libwgpu_native.a"

    # Install examples for sake of testing
    rm_r "examples/vendor"
    inreplace "examples/CMakeLists.txt", "add_subdirectory(vendor/glfw)", ""
    pkgshare.install "examples"
  end

  test do
    system "cmake", "-S", pkgshare/"examples", "-B", "build", "-DCMAKE_BUILD_TYPE=Release"
    system "cmake", "--build", "build", "--target", "compute"

    # Running the built example fails in Intel macOS CI.
    return if ENV["HOMEBREW_GITHUB_ACTIONS"] && OS.mac? && Hardware::CPU.intel?

    cp pkgshare/"examples/compute/shader.wgsl", "."
    assert_match "times: [0, 1, 7, 2]", shell_output("./build/compute/compute")
  end
end
