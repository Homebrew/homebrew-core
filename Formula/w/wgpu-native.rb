class WgpuNative < Formula
  desc "Native WebGPU implementation based on wgpu-core"
  homepage "https://github.com/gfx-rs/wgpu-native"
  url "https://github.com/gfx-rs/wgpu-native.git",
      tag:      "v27.0.2.0",
      revision: "74f8c24c903b6352d09f1928c56962ce06f77a4d"
  license "Apache-2.0"
  head "https://github.com/gfx-rs/wgpu-native.git", branch: "trunk"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "cc3cc51cefc8f7e27d4c3f7b590cb424c9fb45955ebba0e95dcd3f885efd8d3f"
    sha256 cellar: :any,                 arm64_sequoia: "6583720163db34f650f9fe5ec6030a176b3bc416c8f426ed86ee266e6ae9f74e"
    sha256 cellar: :any,                 arm64_sonoma:  "143cfac873e263e3842b6d76ec3a28c317eef445e11843e738d769c840ba5d38"
    sha256 cellar: :any,                 sonoma:        "c24675a336757b536c01bab7e763fa3af001f9354e2a622dfab4d9a8c673cfe2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ac6f17226a9bc9fa18bbb9bfedf8653bdc1f97121eabaf4575bf969264c6d900"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ff6832fbda2bdacd4f36411bd4007b9c19b600b60011e0a0fd0da0487174dbfa"
  end

  depends_on "rust" => :build
  depends_on "cmake" => :test
  depends_on "ninja" => :test
  uses_from_macos "llvm" => :build

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
    system "cmake", "-G", "Ninja",
           "-S", pkgshare/"examples",
           "-B", "build",
           "-DCMAKE_BUILD_TYPE=Release"
    system "cmake", "--build", "build", "--target", "compute"
    # Running the built example fails in CI.
    return if ENV["HOMEBREW_GITHUB_ACTIONS"] && (OS.linux? || Hardware::CPU.intel?)

    cp pkgshare/"examples/compute/shader.wgsl", "."
    assert_match "times: [0, 1, 7, 2]", shell_output("./build/compute/compute")
  end
end
