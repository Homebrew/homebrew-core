class WgpuNative < Formula
  desc "Native WebGPU implementation based on wgpu-core"
  homepage "https://github.com/gfx-rs/wgpu-native"
  url "https://github.com/gfx-rs/wgpu-native.git",
      tag:      "v27.0.4.0",
      revision: "768f15f6ace8e4ec8e8720d5732b29e0b34250a8"
  license "Apache-2.0"
  head "https://github.com/gfx-rs/wgpu-native.git", branch: "trunk"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "5d9096aa62a2380a8701a99199129341f38709c4f5e024eff9300947490716ee"
    sha256 cellar: :any,                 arm64_sequoia: "458c08a381bf1d928149688a4c923e030c26a6e7c377392e892fd22fd5c4a05f"
    sha256 cellar: :any,                 arm64_sonoma:  "c50a895c5a9f4953f348460ca915e18e1c1d93068f947f816f7d497ec7c3f105"
    sha256 cellar: :any,                 sonoma:        "00bb5a82177c270587d840fed5f9dcffd31d1280251874bb1b57dce3af47dbc8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ae9f023013f655e09b7de422b427efda141a69a2d7e3f86c38215858b505eab6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6859115c5a86f4d7e2e4298de573f68b340d22e68edc2e1b9128b1c85d671092"
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
