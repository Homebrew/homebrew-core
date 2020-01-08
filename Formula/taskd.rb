class Taskd < Formula
  desc "Client-server synchronization for todo lists"
  homepage "https://taskwarrior.org/docs/taskserver/setup.html"
  url "https://taskwarrior.org/download/taskd-1.1.0.tar.gz"
  sha256 "7b8488e687971ae56729ff4e2e5209ff8806cf8cd57718bfd7e521be130621b4"
  revision 1
  head "https://github.com/GothenburgBitFactory/taskserver.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "88580976ecb71d4f74d814ff06c88c2082565fee61c7ff8e7f506bce19b460d4" => :catalina
    sha256 "225bedd463f0344572ec985bbb49693dc0b6d5c095c87a5157bcfc437317c1d7" => :mojave
    sha256 "f9737943f0b2877414bf8c0d957a88d79010334a145be6420fd93f64b9569cb3" => :high_sierra
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
