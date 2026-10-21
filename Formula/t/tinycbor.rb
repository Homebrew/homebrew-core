class Tinycbor < Formula
  desc "Concise Binary Object Representation (CBOR) Library"
  homepage "https://github.com/intel/tinycbor"
  url "https://github.com/intel/tinycbor/archive/refs/tags/v7.0.tar.gz"
  sha256 "8b1b76001b9f987677f2ea7aa814fba1f810ff6cbbffa62ea3bac612c55b1a56"
  license "MIT"
  head "https://github.com/intel/tinycbor.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "f44713aa4e533fc1d98eb66deb4831ef7e52b23e743df4863b691b7a9456ae49"
    sha256 cellar: :any, arm64_tahoe:       "7134cf185af770f50043214055e03a195965f64640a2b0105dd431ef1021c9f7"
    sha256 cellar: :any, arm64_sequoia:     "e7c4a105988b2cabfdd3f96ffaed4461262a08934f5922a522ceaa1a3e1dbbb8"
    sha256 cellar: :any, arm64_linux:       "b0236b839d3c5f001aa0430187e74795100db22db489e2d7037545a52878692f"
    sha256 cellar: :any, x86_64_linux:      "91c850008fe081b286515cb7c36b8e2b4074d81246e4a810caae506827888d8a"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :test

  deny_network_access!

  def install
    # Static library is needed for `c2rust`
    system "cmake", "-S", ".", "-B", "buildstatic", *std_cmake_args
    system "cmake", "--build", "buildstatic"
    system "cmake", "--install", "buildstatic"

    # `tinycbor.pc.in` uses `CMAKE_INSTALL_LIBDIR` and `CMAKE_INSTALL_INCLUDEDIR` for `libdir` and `includedir`
    args = %W[
      -DCMAKE_INSTALL_LIBDIR=#{lib}
      -DCMAKE_INSTALL_INCLUDEDIR=#{include}
      -DBUILD_SHARED_LIBS=ON
      -DCMAKE_INSTALL_RPATH=#{rpath}
    ]
    system "cmake", "-S", ".", "-B", "builddyn", *std_cmake_args, *args
    system "cmake", "--build", "builddyn"
    system "cmake", "--install", "builddyn"
  end

  test do
    bindata = [0xb9, 0x00, 0x01, 0x68, 0x68, 0x6f, 0x6d, 0x65, 0x62,
               0x72, 0x65, 0x77, 0x64, 0x74, 0x65, 0x73, 0x74].pack("C*")
    (testpath/"test.bin").binwrite bindata
    assert_equal({ "homebrew" => "test" }, JSON.parse(shell_output("#{bin}/cbordump -j test.bin")))

    (testpath/"test.c").write <<~C
      #include <stdlib.h>
      #include <string.h>
      #include <sys/stat.h>

      #include <cbor.h>

      uint8_t *readfile(const char *fname, size_t *size)
      {
          struct stat st;
          FILE *f = fopen(fname, "rb");
          if (!f) {
              return NULL;
          }
          if (fstat(fileno(f), &st) == -1) {
              return NULL;
          }
          uint8_t *buf = malloc(st.st_size);
          if (buf == NULL) {
              return NULL;
          }
          *size = fread(buf, st.st_size, 1, f) == 1 ? st.st_size : 0;
          fclose(f);
          return buf;
      }

      int main(int argc, char **argv) {
          size_t length;
          uint8_t *buf = readfile(argv[1], &length);

          CborParser parser;
          CborValue it;
          CborError err = cbor_parser_init(buf, length, 0, &parser, &it);

          if (!err) {
              return 0;
          }

          return 1;
      }
    C

    flags = shell_output("pkgconf --cflags --libs tinycbor").chomp.split
    system ENV.cc, "test.c", "-o", "test", *flags
    system testpath/"test", testpath/"test.bin"
  end
end
