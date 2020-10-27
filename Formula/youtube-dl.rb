class YoutubeDl < Formula
  include Language::Python::Virtualenv

  desc "Download YouTube videos from the command-line"
  homepage "https://yt-dl.org"
  url "https://files.pythonhosted.org/packages/12/8b/51cae2929739d637fdfbc706b2d5f8925b5710d8f408b5319a07ea45fe99/youtube_dl-2020.9.20.tar.gz"
  sha256 "67fb9bfa30f5b8f06227c478a8a6ed04af1f97ad4e81dd7e2ce518df3e275391"
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
