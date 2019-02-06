class Ydcv < Formula
  desc "YouDao Console Version"
  homepage "https://github.com/felixonmars/ydcv"
  url "https://github.com/felixonmars/ydcv/archive/0.6.1.tar.gz"
  sha256 "0a01fed567a1045cf6c81da9532ed07852f99dc93c862f59255fda74aab05714"

  bottle :unneeded

  def install
    bin.install "src/ydcv.py" => "ydcv"
    zsh_completion.install "contrib/zsh_completion" => "_ydcv"
  end

  test do
    assert_match "hello", shell_output("#{bin}/ydcv 你好")
    assert_match "你好", shell_output("#{bin}/ydcv hello")
  end
end
