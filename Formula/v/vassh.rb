class Vassh < Formula
  desc "Vagrant Host-Guest SSH Command Wrapper/Proxy/Forwarder"
  homepage "https://github.com/xwp/vassh"
  url "https://github.com/xwp/vassh/archive/0.2.tar.gz"
  sha256 "dd9b3a231c2b0c43975ba3cc22e0c45ba55fbbe11a3e4be1bceae86561b35340"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "024883e4d57b626c8fd7d80f37b44c1cdee15bfb2b7f4f546cb40fdd09e79a08"
  end

  def install
    bin.install "vassh.sh", "vasshin", "vassh"
  end

  test do
    system "#{bin}/vassh", "-h"
  end
end
