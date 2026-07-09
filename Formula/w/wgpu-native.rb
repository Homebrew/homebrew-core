class WgpuNative < Formula
  desc "Native WebGPU implementation based on wgpu-core"
  homepage "https://github.com/gfx-rs/wgpu-native"
  url "https://github.com/gfx-rs/wgpu-native.git",
      tag:      "v29.0.1.1",
      revision: "6aed50955d934ac36049ba8d002034841633ae02"
  license "Apache-2.0"
  head "https://github.com/gfx-rs/wgpu-native.git", branch: "trunk"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "b204aa50abf15cbacfaed382c0d2c6f9d0d0d49b71e06a8d26c2b66ce98dc082"
    sha256 cellar: :any, arm64_sequoia: "b24aac8b8d17043e288ad92be12feade652e9de73d49c72800ef9ae7e7f95552"
    sha256 cellar: :any, arm64_sonoma:  "84c5693fb760cb9ab8d8c4feaed584c24152b172216f0777dfc4b8ccb2191ef8"
    sha256 cellar: :any, sonoma:        "8ba08dab0972a14828b88e853559af3d9a479f6b69ba54085bfe41946dddd655"
    sha256 cellar: :any, arm64_linux:   "a34b2309bb9a4f42720d932ff1c394d68e0dc0ec517e8d1eeec314c983dae062"
    sha256 cellar: :any, x86_64_linux:  "e5d2ad6914baf11090337d3e302f6304f849887de8c8b8177b9c81aec55541ce"
  end

  depends_on "rust" => :build
  depends_on "cmake" => :test
  uses_from_macos "llvm" => :build

  on_linux do
    depends_on "mesa" => :test
  end

  def install
    ENV["LIBCLANG_PATH"] = formula_opt_lib("llvm").to_s if OS.linux?
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
