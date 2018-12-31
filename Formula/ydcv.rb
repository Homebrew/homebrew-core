class Ydcv < Formula
  desc "YouDao Console Version"
  homepage "https://github.com/felixonmars/ydcv"
  url "https://github.com/felixonmars/ydcv/archive/0.6.tar.gz"
  sha256 "5388da76b742f0c0e578f229a776ed3d3ec5cb91286a6244ba122880e9785a75"

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
