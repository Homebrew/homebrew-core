class YoutubeDl < Formula
  include Language::Python::Virtualenv

  desc "Download YouTube videos from the command-line"
  homepage "https://youtube-dl.org/"
  url "https://files.pythonhosted.org/packages/b6/d5/f003ec65e6bcfe475abddbfb3271159736be6ebca2ab95796c0f2e8ee184/youtube_dl-2020.11.29.tar.gz"
  sha256 "849d2a85ee99e5caafc8d52572bb603c4ae020dfb615a4d51c3bc90787d40df3"
  license "Unlicense"

  bottle do
    cellar :any_skip_relocation
    sha256 "6fbc1ea5f42cc06e10e50cc3beaa3597c7ab9fa7c49a160d4241ba7fffe0029b" => :big_sur
    sha256 "ebde2db428b244f2caccde9655c658443adc82d2e79f8671dcb51c7dfa673c05" => :catalina
    sha256 "3e28af7663ce5209a258aa63366d4f77da7f79155d1c5eef70329e09b8543e62" => :mojave
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
