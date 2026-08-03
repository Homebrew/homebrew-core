class Xeve < Formula
  desc "Very fast Essential Video Encoder, MPEG-5 EVC (Essential Video Coding)"
  homepage "https://github.com/mpeg5/xeve"
  url "https://github.com/mpeg5/xeve.git",
      tag:      "v0.5.1",
      revision: "d7352a9d49d07dc162aa4137a1b9c32bfb3efb40"
  license "BSD-3-Clause"
  head "https://github.com/mpeg5/xeve.git", branch: "master"

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
    # Fix building xeve_app on macOS. See https://github.com/mpeg5/xeve/commit/c564ac77c103dbba472df3e13f4733691fd499ed
    # and https://github.com/mpeg5/xeve/commit/e029f1619ecedbda152b8680641fa10eea9eeace
    if OS.mac? && !build.head?
      inreplace "CMakeLists.txt", "set(CMAKE_EXE_LINKER_FLAGS \"-static\")",
                                  "#set(CMAKE_EXE_LINKER_FLAGS \"-static\")"
      inreplace "app/xeve_app_util.h", "#elif __linux__ || __CYGWIN__",
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
    (testpath/"test.c").write <<~C
      #include <xeve.h>
      #include <stdlib.h>
      #include <string.h>

      #define MAX_BITSTREAM_SIZE (10*1000*1000) /* 10Mbyte, need to be set properly */

      int main() {
        /* prepare coding parameters ***************************/
        XEVE_CDSC cdsc;
        cdsc.max_bs_buf_size = MAX_BITSTREAM_SIZE;

        /* get default parameters */
        xeve_param_default(&cdsc.param);

        /* set specific profile, preset, tune, if needs */
        xeve_param_ppt(&cdsc.param, XEVE_PROFILE_BASELINE, XEVE_PRESET_SLOW, XEVE_TUNE_NONE);

        /* create new instance *********************************/
        XEVE id = xeve_create(&cdsc, NULL);

        /* encode pictures *************************************/
        XEVE_BITB bitb; /* bitstream buffer */
        memset(&bitb, 0, sizeof(XEVE_BITB));
        bitb.addr = malloc(MAX_BITSTREAM_SIZE); /* assign buffer */
        bitb.bsize = MAX_BITSTREAM_SIZE;

        /* clean-up ********************************************/
        xeve_delete(id);
        return 0;
      }
    C

    system ENV.cc, "test.c", "-I#{include}/xeve", "-L#{lib}", "-lm", "-lxeve", "-o", "test"
    system "./test"
  end
end
