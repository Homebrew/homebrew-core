class WgpuNative < Formula
  desc "Native WebGPU implementation based on wgpu-core"
  homepage "https://github.com/gfx-rs/wgpu-native"
  url "https://github.com/gfx-rs/wgpu-native.git",
      tag:      "v29.0.0.0",
      revision: "d2e3330ade4ae1bb238d76b485926f067e7ee64c"
  license "Apache-2.0"
  head "https://github.com/gfx-rs/wgpu-native.git", branch: "trunk"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "7cc3b38e9e319ae09bd3aebfb8f9b25143fd0b1115133f8d8e746e7fcff559a2"
    sha256 cellar: :any,                 arm64_sequoia: "ec305f91cca1a09a7b560563d35eab486f3ed1985f1bfca11328e69cee5a82cd"
    sha256 cellar: :any,                 arm64_sonoma:  "09c1a3c1a9c108a97a8f48c56f82009ce15cac0ae48d50b13a8dbd0ce2d9fb98"
    sha256 cellar: :any,                 sonoma:        "3325394962e971ba056dc7c533613d789e3f0d28c5013056c3c3414bf8bc2ce0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5e204deee10c0452c9fe23492faa5b497b37ec37dbdb9c995d36f5599d025010"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "07f40872287f69103207325022fc2176e180ce060b2dab932e203443690013a7"
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
