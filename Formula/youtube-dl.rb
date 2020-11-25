class YoutubeDl < Formula
  include Language::Python::Virtualenv

  desc "Download YouTube videos from the command-line"
  homepage "https://youtube-dl.org/"
  url "https://files.pythonhosted.org/packages/79/88/05bc5ff2b03a218650523ee09f00465e95c278fe0105beda24cb756804c7/youtube_dl-2020.11.24.tar.gz"
  sha256 "f701befffe00ae4b0d56f88ed45e1295c151c340d0011efdb1005012abc81996"
  license "Unlicense"

  bottle do
    cellar :any_skip_relocation
    sha256 "2f8a82a4cec363105b0bd47bbdd8d2b77b2b9f4081f28f2e518bf079570429a7" => :big_sur
    sha256 "6fa05a6ef2b453405a6acf28e30619228a1b670186b4c7b3140f71a74c86543d" => :catalina
    sha256 "895248fdbb967d82bf9c6520f953abe7c272e541a033f71445df9a0cf5e7f4f5" => :mojave
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
