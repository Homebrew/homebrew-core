class YoutubeDl < Formula
  include Language::Python::Virtualenv

  desc "Download YouTube videos from the command-line"
  homepage "https://youtube-dl.org/"
  url "https://files.pythonhosted.org/packages/f3/81/86da9f2bcbea4d7315f05bbf4c12ef74fee5eddd64f9c5255e8f1e410bc2/youtube_dl-2020.11.26.tar.gz"
  sha256 "3d52d2c969ec9521a086c43f809fd7545708b7ba24d7379fb123b5438ba691e1"
  license "Unlicense"

  bottle do
    cellar :any_skip_relocation
    sha256 "8160bbf37e79e368936244d9629469e4ef2638c51002d2d921fd0f12bc17f85c" => :big_sur
    sha256 "7305c4f4b9b2a1c0c2fe4473f40d26813f0b7ffe4b25c36200f081e09f910deb" => :catalina
    sha256 "cadcbc698b805ad935ebe71f04ee9ef8efa9e06feb94aafa15d92507b5893738" => :mojave
  end

  depends_on "python@3.9"

  def install
    virtualenv_install_with_resources
    man1.install_symlink libexec/"share/man/man1/youtube-dl.1" => "youtube-dl.1"
  end

  test do
    # commit history of homebrew-core repo
    system "#{bin}/youtube-dl", "--simulate", "https://www.youtube.com/watch?v=pOtd1cbOP7k"
    # homebrew playlist
    system "#{bin}/youtube-dl", "--simulate", "--yes-playlist", "https://www.youtube.com/watch?v=pOtd1cbOP7k&list=PLMsZ739TZDoLj9u_nob8jBKSC-mZb0Nhj"
  end
end
