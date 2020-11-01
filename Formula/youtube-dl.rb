class YoutubeDl < Formula
  include Language::Python::Virtualenv

  desc "Download YouTube videos from the command-line"
  homepage "https://youtube-dl.org/"
  url "https://files.pythonhosted.org/packages/2d/70/bd9ec7f14efab2811fc4bd39cd586ed5e292547552310ee863ff84fa7791/youtube_dl-2020.11.1.1.tar.gz"
  sha256 "b73379d6b08f03aec49a1899affe4cfd35bb92002dbdb3a3a1435a5811d4f120"
  license "Unlicense"

  bottle do
    cellar :any_skip_relocation
    sha256 "6553843d76f95feeb9a488b2a14cb8374b313f02bd72b18d75cbbd2270fe11ee" => :catalina
    sha256 "8a6f47c7bf197a9cb40e08d130ce6ac9530d2c77f4ecd92f838e19abe23f2c5a" => :mojave
    sha256 "7b797964bed458c4271ad917373155a9be574afc174bfdda14b73a77fb16cbc5" => :high_sierra
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
