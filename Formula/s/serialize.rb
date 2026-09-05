class Serialize < Formula
  desc "Single-header bitpacking serializer for C++ aimed at game networking"
  homepage "https://github.com/mas-bandwidth/serialize"
  url "https://github.com/mas-bandwidth/serialize/archive/refs/tags/v1.16.2.tar.gz"
  sha256 "84ca9c238afe61f34aead2be2140c1ed40d9c1370face7710e823341534da3ad"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "15a64f815b1b4d1e4806a7bd952a6f7bf9d5b471966cd5320eacb16af2b069e8"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", "-DSERIALIZE_BUILD_TESTS=OFF", *std_cmake_args
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <serialize.h>
      int main()
      {
          uint8_t buffer[64];
          memset( buffer, 0, sizeof( buffer ) );
          serialize::WriteStream writer( buffer, 64 );
          uint32_t written = 12345;
          writer.SerializeBits( written, 14 );
          writer.Flush();
          serialize::ReadStream reader( buffer, writer.GetBytesProcessed() );
          uint32_t value = 0;
          reader.SerializeBits( value, 14 );
          return value == 12345 ? 0 : 1;
      }
    CPP
    system ENV.cxx, "test.cpp", "-I#{include}", "-o", "test"
    system "./test"
  end
end
