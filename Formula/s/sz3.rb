class Sz3 < Formula
  desc "Error-bounded lossy compressor for scientific floating-point data"
  homepage "https://github.com/szcompressor/SZ3"
  url "https://github.com/szcompressor/SZ3/archive/refs/tags/v3.4.0.tar.gz"
  sha256 "d8d4c8a3602c23fd084c0bf72ff4ce4a9121c3e2ccfdc7ed8492ee03ec70a23a"
  # The `:cannot_represent` is for copyright-and-BSD-license.txt, which is similar to
  # BSD-3-Clause-Attribution but asks that modifications be noted and words its acknowledgment clause differently.
  # include/SZ3/encoder/XtcBasedEncoder.hpp is LGPL-2.1-or-later.
  license all_of: [:cannot_represent, "LGPL-2.1-or-later"]
  head "https://github.com/szcompressor/SZ3.git", branch: "master"

  depends_on "cmake" => [:build, :test]
  depends_on "pkgconf" => :build
  depends_on "zstd"

  on_macos do
    depends_on "libomp"
  end

  deny_network_access!

  def install
    args = %W[
      -DBUILD_SHARED_LIBS=ON
      -DBUILD_SZ3_BINARY=ON
      -DBUILD_H5Z_FILTER=OFF
      -DSZ3_USE_BUNDLED_ZSTD=OFF
      -DCMAKE_INSTALL_RPATH=#{rpath}
    ]
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    assert_match "SZ3 Version: #{version}", shell_output("#{bin}/sz3 -v")
    assert_match "Smoke test passed", shell_output(bin/"sz3_smoke_test")

    values = Array.new(8 * 8 * 16) { |i| Math.sin(i / 10.0) * 100.0 }
    (testpath/"in.f32").binwrite(values.pack("e*"))
    system bin/"sz3", "-f", "-i", "in.f32", "-z", "out.sz", "-3", "8", "8", "16", "-M", "ABS", "1e-3"
    assert_operator (testpath/"out.sz").size, :<, (testpath/"in.f32").size
    system bin/"sz3", "-f", "-z", "out.sz", "-o", "out.f32", "-3", "8", "8", "16"
    decompressed = (testpath/"out.f32").binread.unpack("e*")
    assert_equal values.size, decompressed.size
    input = (testpath/"in.f32").binread.unpack("e*")
    max_error = input.zip(decompressed).map { |a, b| (a - b).abs }.max
    assert_operator max_error, :<=, 1e-3

    (testpath/"test.cpp").write <<~CPP
      #include <SZ3/api/sz.hpp>
      #include <cmath>
      #include <cstdio>
      #include <vector>

      int main() {
        SZ3::Config conf(16, 16, 16);
        conf.errorBoundMode = SZ3::EB_ABS;
        conf.absErrorBound = 1e-3;
        std::vector<float> data(conf.num);
        for (size_t i = 0; i < conf.num; i++) data[i] = std::sin(i * 0.01f);
        size_t cmp_size = 0;
        char *cmp = SZ_compress(conf, data.data(), cmp_size);
        float *dec = nullptr;
        SZ_decompress(conf, cmp, cmp_size, dec);
        double max_err = 0;
        for (size_t i = 0; i < conf.num; i++) max_err = std::fmax(max_err, std::fabs(dec[i] - data[i]));
        std::printf("%s\\n", max_err <= 1e-3 && cmp_size < conf.num * sizeof(float) ? "ok" : "fail");
        delete[] cmp;
        delete[] dec;
        return 0;
      }
    CPP

    (testpath/"CMakeLists.txt").write <<~CMAKE
      cmake_minimum_required(VERSION 3.19)
      project(test_sz LANGUAGES CXX)
      find_package(SZ3 3.4 REQUIRED)
      add_executable(test test.cpp)
      target_link_libraries(test PRIVATE SZ3::SZ3core)
    CMAKE

    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    assert_equal "ok", shell_output("./build/test").strip

    (testpath/"test_c.c").write <<~C
      #include <SZ3c/sz3c.h>
      #include <math.h>
      #include <stdio.h>

      int main(void) {
        float data[16 * 16 * 16];
        for (int i = 0; i < 16 * 16 * 16; i++) data[i] = sinf(i * 0.01f);
        size_t cmp_size = 0;
        unsigned char *cmp = SZ_compress_args(SZ_FLOAT, data, &cmp_size, ABS, 1e-3, 0, 0, 0, 0, 16, 16, 16);
        float *dec = (float *)SZ_decompress(SZ_FLOAT, cmp, cmp_size, 0, 0, 16, 16, 16);
        double max_err = 0;
        for (int i = 0; i < 16 * 16 * 16; i++) {
          double err = fabs((double)dec[i] - data[i]);
          if (isnan(err) || err > max_err) max_err = err;
        }
        printf("%s\\n", max_err <= 1e-3 && cmp_size < sizeof(data) ? "ok" : "fail");
        free_buf(cmp);
        free_buf(dec);
        return 0;
      }
    C
    system ENV.cc, "test_c.c", "-I#{include}", "-L#{lib}", "-lSZ3c", "-lm", "-o", "test_c"
    assert_equal "ok", shell_output("./test_c").strip
  end
end
