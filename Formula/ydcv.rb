class Ydcv < Formula
  desc "YouDao Console Version"
  homepage "https://github.com/felixonmars/ydcv"
  url "https://github.com/felixonmars/ydcv/archive/0.4.tar.gz"
  sha256 "2d9f6309bbf2d35c0c34c5ee945cf40769cc8201e6f374fa2a4f2d4b827fbdbb"

  depends_on :python if MacOS.version <= :snow_leopard

  def install
    bin.install "ydcv.py" => "ydcv"
    zsh_completion.install "contrib/zsh_completion" => "_ydcv"
  end

  test do
    {
      "hello" => "你好",
      "你好" => "hello",
    }.each do |foreign, translated|
      assert_true shell_output("#{bin}/ydcv #{foreign}").include? translated
    end
  end
end
