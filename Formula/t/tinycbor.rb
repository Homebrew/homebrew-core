class Tinycbor < Formula
  desc "Concise Binary Object Representation (CBOR) Library"
  homepage "https://github.com/intel/tinycbor"
  url "https://github.com/intel/tinycbor/archive/refs/tags/v7.1.tar.gz"
  sha256 "08c0a4c0a983000806f3d8c1599ec07995789ae49e9a23034db4cbfccc81c2e5"
  license "MIT"
  compatibility_version 1
  head "https://github.com/intel/tinycbor.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "69bb0fb4fe8219830f9da5a9ea943b6712a89f0f11cfab53e161c511b55206a9"
    sha256 cellar: :any, arm64_tahoe:       "9adda5625b21c4893bcfb858dc936594b3581cba54386aadb6b39a72f9afbb55"
    sha256 cellar: :any, arm64_sequoia:     "65438bea60631c2f6b8f31d672cefbf84d2cfb6246c224078f8d0f3b029ed60c"
    sha256 cellar: :any, arm64_linux:       "1bfaf2fa31faf745250e52f2229606c363f076a8803653a0d2ec364a8007402b"
    sha256 cellar: :any, x86_64_linux:      "cc448c9b0c6e2bc2c0c545a869412c54ba36e4c1921f49dab8ddc02acacdf0a4"
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
