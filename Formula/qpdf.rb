class Qpdf < Formula
  desc "Tools for and transforming and inspecting PDF files"
  homepage "https://github.com/qpdf/qpdf"
  url "https://github.com/qpdf/qpdf/releases/download/v11.2.0/qpdf-11.2.0.tar.gz"
  sha256 "fbd2d75050933487929dbbe1b5c50a238487194bc7263c277d6e49abb90ab7f2"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "41b4f1689615b64fc321da6a0dc88de085a16e3b2f2855d2b46305bf3c920749"
    sha256 cellar: :any,                 arm64_monterey: "d5dc7f05aaf62794ccbcd7416e20750a76bdb237edd8ce50b2a57c74e14f526d"
    sha256 cellar: :any,                 arm64_big_sur:  "eb0a4ddb0026e5ff1c963548f05512a5f24fabd9adbf530496b301242ddf3f4c"
    sha256 cellar: :any,                 ventura:        "0c925ae43e085a33f982bf9d775f4629dfe4a9c438131fa84aac0d84d026f20d"
    sha256 cellar: :any,                 monterey:       "02674cf95d7d3cd0a3211f24e741ea89171a3ee442d392ebab3011475a10ec49"
    sha256 cellar: :any,                 big_sur:        "903f5103d2b5e68b145bcc94f50e37c333444092651fdd08c7505b01a2c395cd"
    sha256 cellar: :any,                 catalina:       "9def57863e5ee1aab7aa99ba0106daa564c2eb7ec6e727c959fd5e6e53d83b11"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "15a4e4bb40d7620fe671d133a9d3bdc9707247c675edc818d864288ff31b53f7"
  end

  depends_on "cmake" => :build
  depends_on "jpeg-turbo"
  depends_on "openssl@1.1"

  uses_from_macos "zlib"

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DUSE_IMPLICIT_CRYPTO=0",
                    "-DREQUIRE_CRYPTO_OPENSSL=1",
                    "-DCMAKE_INSTALL_RPATH=#{rpath}",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system "#{bin}/qpdf", "--version"
  end
end
