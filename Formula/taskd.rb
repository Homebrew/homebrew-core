class Taskd < Formula
  desc "Client-server synchronization for todo lists"
  homepage "https://taskwarrior.org/docs/taskserver/setup.html"
  url "https://taskwarrior.org/download/taskd-1.1.0.tar.gz"
  sha256 "7b8488e687971ae56729ff4e2e5209ff8806cf8cd57718bfd7e521be130621b4"
  revision 1

  head "https://github.com/GothenburgBitFactory/taskserver.git"

  bottle do
    sha256 "53ea3abeff00da4d69f53d089416c1e003bae625decbc44412b8ff51b9ccf302" => :high_sierra
    sha256 "93b3a449cc983885491a01511275b3b4b8ff6cc624aa4326a9e268d4a28ff4af" => :sierra
    sha256 "d7806f456a540d6052928f6e1c9fcd5e89f0d1b3c5496d552e187b117fc94b24" => :el_capitan
    sha256 "2c1a95a98ea309c776ab0f210fd8a9297bc866e25b2ee7ba0301d6f8df531a2a" => :yosemite
    sha256 "a83899074cf81fcf6737546f9f572db6ce1a8762af943e7663fe14760fd5ef77" => :mavericks
  end

  depends_on "cmake" => :build
  depends_on "gnutls"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    system "#{bin}/taskd", "init", "--data", testpath
  end
end
