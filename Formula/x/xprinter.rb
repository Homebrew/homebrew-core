class Xprinter < Formula
  desc "Driver of xprinter"
  homepage "https://rjgcs.github.io/xprinter/"
  url "https://github.com/rjgcs/xprinter/releases/download/v1.0.1/xprinter-1.0.1.tar.xz"
  sha256 "a1e29389e1f01f350f6a54d394e12e0864d8214fd5fc2bc83051c6fc90191901"
  license "MIT"

  def install
    bin.install "xprinter"
    bin.install "xprinter-server-brew"
  end

  def post_install
    system "nohup #{bin}/xprinter server > /dev/null 2>&1 &"
    system "nohup #{bin}/xprinter-server-brew > /dev/null 2>&1 &"
  end  

  test do
    # 测试 xprinter 的功能，比如获取版本
    assert_match "1.0.0", shell_output("#{bin}/xprinter --version")
  end
end
