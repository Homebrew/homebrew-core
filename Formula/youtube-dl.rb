class YoutubeDl < Formula
  include Language::Python::Virtualenv

  desc "Download YouTube videos from the command-line"
  homepage "https://youtube-dl.org/"
  url "https://files.pythonhosted.org/packages/e5/1f/a9e2ec4219761bb9ec568fb5457bd870627c2556d6bd2ce8cdbea8694cde/youtube_dl-2020.11.12.tar.gz"
  sha256 "1491df1707f47207bfd47dd8497d26e9125dd9e4fe2e00780103d4c1b4b2088d"
  license "Unlicense"

  bottle do
    cellar :any_skip_relocation
    sha256 "9efe9b88dd4999412396bde9543b65152fcf5e75b25307b39826c8b3149369ce" => :catalina
    sha256 "a31510083974a5feca324255b43d9f7b2261fb66776a1852e15bc646144dd3b6" => :mojave
    sha256 "44afe4d34e4f6813139128c54b6afe740d03a9753acf8f5e164732e3933e2546" => :high_sierra
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
