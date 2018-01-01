class Ydcv < Formula
  desc "YouDao Console Version"
  homepage "https://github.com/felixonmars/ydcv"
  url "https://github.com/felixonmars/ydcv/archive/0.5.tar.gz"
  sha256 "8f030c15d241ff317381cf97bacf3140080e34c1a4c4c685265dfdb05c8b8a10"

  bottle :unneeded

  depends_on "python" if MacOS.version <= :snow_leopard

  def install
    bin.install "src/ydcv.py" => "ydcv"
    zsh_completion.install "contrib/zsh_completion" => "_ydcv"
  end

  test do
    assert_match "hello", shell_output("#{bin}/ydcv 你好")
    assert_match "你好", shell_output("#{bin}/ydcv hello")
  end
end
