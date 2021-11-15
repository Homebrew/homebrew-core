class Slowhttptest < Formula
  desc "Simulates application layer denial of service attacks"
  homepage "https://github.com/shekyan/slowhttptest"
  url "https://github.com/shekyan/slowhttptest/archive/v1.8.2.tar.gz"
  sha256 "faa83dc45e55c28a88d3cca53d2904d4059fe46d86eca9fde7ee9061f37c0d80"
  license "Apache-2.0"
  revision 1
  head "https://github.com/shekyan/slowhttptest.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "6b6d59d5b4e58bb345a47a7932a27c55412370bf7dccb11ec747a71a1ebfcb05"
    sha256 cellar: :any,                 arm64_big_sur:  "cc98e77420edf6c9304650871991d7df7f89dd99381a63f021bdef192d9b1e37"
    sha256 cellar: :any,                 monterey:       "d8002aae9aff1398247b06496220bbbff13714dd407c289c1ec550bb5fdfbde2"
    sha256 cellar: :any,                 big_sur:        "8414f5f6736cdaac257f0c96ecf0a72526c80595b7e966d26a0c99aaba25a8dc"
    sha256 cellar: :any,                 catalina:       "7cd865ac1b118d8ef7bdf0b540f56140ff4254e7a38d2b22d520c9bd1158df5d"
    sha256 cellar: :any,                 mojave:         "f4da64ee55ba56ffaff0d383954d0e13577326dbca30b431d5d89775dcfb396e"
    sha256 cellar: :any,                 high_sierra:    "3ffeaec203cd16a00aeb0bf239dfe5b32087e35a74dd5c6917bd3e7a2a09848f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3f6da4dc3f06b54d5bb48e22ef34810b779c950bfb108cc49ee8970975030879"
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
