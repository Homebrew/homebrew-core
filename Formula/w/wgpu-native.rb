class WgpuNative < Formula
  desc "Native WebGPU implementation based on wgpu-core"
  homepage "https://github.com/gfx-rs/wgpu-native"
  url "https://github.com/gfx-rs/wgpu-native.git",
      tag:      "v25.0.2.2",
      revision: "a2f5109b0da3c87d356a6a876f5b203c6a68924a"
  license "Apache-2.0"
  head "https://github.com/gfx-rs/wgpu-native.git", branch: "trunk"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "eb7550d1d1531c1591d52f2b00118332e0830e2531dfd145ec4dbdc56069753f"
    sha256 cellar: :any,                 arm64_sequoia: "8573e6bc96bdc85ad271be5242a5b7c137de80a0e8ac4e570079f7ecc7b40c43"
    sha256 cellar: :any,                 arm64_sonoma:  "2dd7b2ed450d367419f5b163e1d7c91778ae00038ef9a15e6743eac9109ac737"
    sha256 cellar: :any,                 arm64_ventura: "b4c0515ef990fc88f3eb95c24799b6e7ca5a98cb50b451904734058cc51acd4b"
    sha256 cellar: :any,                 sonoma:        "80db9538177c5953cc6222a78ab66a6060b59db4d0bcc259fd11459d967eeb74"
    sha256 cellar: :any,                 ventura:       "3d2424e90cf2cf44f363ceeb2bf52e82eb81903bd3ab8c8ef70ca06c29be2903"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6c5735eec213b0d183b2e656103a810c36c67e42039512db2007a903cd0be24a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b4f6b2980e8428dd9bc67393990f8a2d9da2acfc0838c8eb3cd6c85a6f8aa4ea"
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
