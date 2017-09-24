class Xrootd < Formula
  desc "High performance, scalable, fault-tolerant access to data"
  homepage "http://xrootd.org"
  url "http://xrootd.org/download/v4.7.0/xrootd-4.7.0.tar.gz"
  sha256 "6cc69d9a3694e8dcf2392e9c3b518bd2497a89b3a9f25ffaec62efa52170349b"
  head "https://github.com/xrootd/xrootd.git"

  bottle do
    cellar :any
    sha256 "ff20b8c7432053666832be1c43e75ed576aedbe5048401c38cd71a4d48fd4f3f" => :high_sierra
    sha256 "160388da6e8c9bfbbfc27db27accdb3a90a88dabd235c027efa2708d1e17d34c" => :sierra
    sha256 "35cd7917c26017c2ca6946f2bc35a1273dda8a7244aa096fa270c2fa4c3abdf5" => :el_capitan
    sha256 "c2202a8eba69a6c75dcc52a18ee3a602917a3c6f78d96a093dbecd7f38a121d1" => :yosemite
  end

  depends_on "cmake" => :build
  depends_on "openssl"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    system "#{bin}/xrootd", "-H"
  end
end
