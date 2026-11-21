class Serialize < Formula
  desc "Single-header bitpacking serializer for C++ aimed at game networking"
  homepage "https://github.com/mas-bandwidth/serialize"
  url "https://github.com/mas-bandwidth/serialize/archive/refs/tags/v2.1.6.tar.gz"
  sha256 "6296e40a2fe58d080363f1950763d100219dcbd3def3c4a60c1461c9bc16f6bf"
  license "BSD-3-Clause"
  compatibility_version 1

  bottle do
    manifest_sha256 "511dd3cec14e139df127d2854d60f358e14a79758be768b37f1aa3cf938e8f43"
    sha256 cellar: :any_skip_relocation, all: "b8e16647efe34d8dd28f7c52c2e3f0e09a35da888dcb0ea3ae2ca0319830fc36"
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
