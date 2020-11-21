class YoutubeDl < Formula
  include Language::Python::Virtualenv

  desc "Download YouTube videos from the command-line"
  homepage "https://youtube-dl.org/"
  url "https://files.pythonhosted.org/packages/76/03/a5c749ea2ddeac51dcd0376d8519868ca710dd241c871f555765e777c5bf/youtube_dl-2020.11.21.1.tar.gz"
  sha256 "a785c1373a3c2d0b82c54aabc4831e8e6f6ede059ec462e54526d694dd3c29ca"
  license "Unlicense"

  bottle do
    cellar :any_skip_relocation
    sha256 "ab39ad3bf8b1d5c55f84bf2c1fde0ba8d41f50fe0ed1913ca0825ec92b9faee3" => :big_sur
    sha256 "34333494e19cfa8e739c3a085126ba0554e057c26aa7f9d7c1a6b021bcd9b634" => :catalina
    sha256 "4004d4789fa6b72447e852c8064292b5b14ae11a2d01b10b2be99e0d8de1f075" => :mojave
  end

  depends_on "python@3.9"

  def install
    virtualenv_install_with_resources
  end

  test do
    # commit history of homebrew-core repo
    system "#{bin}/youtube-dl", "--simulate", "https://www.youtube.com/watch?v=pOtd1cbOP7k"
    # homebrew playlist
    system "#{bin}/youtube-dl", "--simulate", "--yes-playlist", "https://www.youtube.com/watch?v=pOtd1cbOP7k&list=PLMsZ739TZDoLj9u_nob8jBKSC-mZb0Nhj"
  end
end
