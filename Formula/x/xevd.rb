class Xevd < Formula
  desc "Very fast Essential Video Decoder, MPEG-5 EVC (Essential Video Coding)"
  homepage "https://github.com/mpeg5/xevd"
  url "https://github.com/mpeg5/xevd.git",
      tag:      "v0.5.0",
      revision: "70e18a507022790339690407c263ac172ace3cb0"
  license "BSD-3-Clause"
  head "https://github.com/mpeg5/xevd.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  depends_on "cmake" => :build

  on_arm do
    depends_on "sse2neon" => :build
  end

  def install
    args = []
    if Hardware::CPU.arm? && !build.head?
      # Update sse2neon.h to fix build issues.
      cp formula_opt_include("sse2neon")/"sse2neon.h", buildpath/"src_base/neon/sse2neon.h"

      args << "-DARM=TRUE"
    end
    # Fix building xevd_app on macOS. See https://github.com/mpeg5/xevd/commit/adf1c45d6edb0d235997a40261689d7454b711c5
    # and https://github.com/mpeg5/xevd/commit/c1f23a41b8def84ab006a8ce4e9221b2fff84a1a
    if OS.mac? && !build.head?
      inreplace "CMakeLists.txt", "set(CMAKE_EXE_LINKER_FLAGS \"-static\")",
                                  "#set(CMAKE_EXE_LINKER_FLAGS \"-static\")"
      inreplace "app/xevd_app_util.h", "#elif __linux__ || __CYGWIN__",
                                       "#elif __linux__ || __CYGWIN__ || __APPLE__"
    end

    %w[BASE MAIN].each do |prof|
      system "cmake", "-S", ".", "-B", "build",
                      "-DSET_PROF=#{prof}", *args, *std_cmake_args
      system "cmake", "--build", "build"
      system "cmake", "--install", "build"
    end
  end

  test do
    system bin/"xevd_app", "-i", File::NULL, "-o", "output.yuv"
  end
end
