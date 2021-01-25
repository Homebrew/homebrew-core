class Slowhttptest < Formula
  desc "Simulates application layer denial of service attacks"
  homepage "https://github.com/shekyan/slowhttptest"
  url "https://github.com/shekyan/slowhttptest/archive/v1.8.2.tar.gz"
  sha256 "faa83dc45e55c28a88d3cca53d2904d4059fe46d86eca9fde7ee9061f37c0d80"
  license "Apache-2.0"
  revision 1
  head "https://github.com/shekyan/slowhttptest.git"

  bottle do
    cellar :any
    sha256 "8414f5f6736cdaac257f0c96ecf0a72526c80595b7e966d26a0c99aaba25a8dc" => :big_sur
    sha256 "cc98e77420edf6c9304650871991d7df7f89dd99381a63f021bdef192d9b1e37" => :arm64_big_sur
    sha256 "7cd865ac1b118d8ef7bdf0b540f56140ff4254e7a38d2b22d520c9bd1158df5d" => :catalina
    sha256 "f4da64ee55ba56ffaff0d383954d0e13577326dbca30b431d5d89775dcfb396e" => :mojave
    sha256 "3ffeaec203cd16a00aeb0bf239dfe5b32087e35a74dd5c6917bd3e7a2a09848f" => :high_sierra
  end

  # Remove these in next version
  depends_on "autoconf" => :build
  depends_on "automake" => :build

  depends_on "openssl@1.1"

  def install
    inreplace "configure.ac", "1.8.1", "1.8.2"
    system "autoconf" # Remove in next version
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/slowhttptest", "-u", "https://google.com",
                                  "-p", "1", "-r", "1", "-l", "1", "-i", "1"

    assert_match version.to_s, shell_output("#{bin}/slowhttptest -h", 1)
  end
end
