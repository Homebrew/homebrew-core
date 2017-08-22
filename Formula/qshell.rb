class Qshell < Formula
  desc "Qiniu Cloud Resource Management Tool "
  homepage "https://github.com/qiniu/qshell"
  url "https://dn-devtools.qbox.me/qshell-2.1.3.tar.gz"
  sha256 "26cad79300c471f34f52def329635f5405f520c7b662b6488a942173e1e93342"

  def install
    system "make", "install"
  end

  test do
    system "false"
  end
end
