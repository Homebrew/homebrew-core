class Serialize < Formula
  desc "Single-header bitpacking serializer for C++ aimed at game networking"
  homepage "https://github.com/mas-bandwidth/serialize"
  url "https://github.com/mas-bandwidth/serialize/archive/refs/tags/v2.1.7.tar.gz"
  sha256 "ba8c33633fce5a8b60c72b441459ab45b649114c1ebddf1868e3edb94b07fe19"
  license "BSD-3-Clause"
  compatibility_version 1

  bottle do
    manifest_sha256 "e79660328b2f74a74c8889207a73ce49e6ca642a054dc86c4043896f822318da"
    sha256 cellar: :any_skip_relocation, all: "8c9802c03e01837adc9c4ea069a5dce4eaa81fdb823bc4e3afb42fa7da69c4d7"
  end

  depends_on "cmake" => :build

  deny_network_access!

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
