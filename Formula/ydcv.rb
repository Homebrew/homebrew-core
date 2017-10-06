class Ydcv < Formula
  desc "YouDao Console Version - Simple wrapper for Youdao online translate (Chinese <-> English) service API, as an alternative to the StarDict Console Version(sdcv)."
  homepage "https://github.com/felixonmars/ydcv"
  url "https://github.com/felixonmars/ydcv/archive/0.4.tar.gz"
  sha256 "2d9f6309bbf2d35c0c34c5ee945cf40769cc8201e6f374fa2a4f2d4b827fbdbb"

  depends_on "python3"

  def install
    bin.install "ydcv.py" => "ydcv"
    zsh_completion.install "contrib/zsh_completion" => "_ydcv"
  end

  test do
    system "#{bin}/ydcv", "hello"
  end
end
