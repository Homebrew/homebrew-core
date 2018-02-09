class YouGet < Formula
  include Language::Python::Virtualenv

  desc "Dumb downloader that scrapes the web"
  homepage "https://you-get.org/"
  url "https://github.com/soimort/you-get/releases/download/v0.4.1025/you-get-0.4.1025.tar.gz"
  sha256 "d348b89bd4798ef2225f5b357510505a4bc781380479c9f59b69d80ff9a56ab5"
  head "https://github.com/soimort/you-get.git", :branch => "develop"

  bottle do
    cellar :any_skip_relocation
    sha256 "af24977c2f630cc312dc0ca6674dde3601b03f2d88334f4dd8bb248e3c4fb676" => :high_sierra
    sha256 "cfff31c71c48331ae3992a49f3e82a92af171910169e2f249b5a1e78a4454563" => :sierra
    sha256 "829117daa85468f4884938d7f3e37469820cb55ed219424c6b68163d43db6bae" => :el_capitan
  end

  depends_on "python3"

  depends_on "rtmpdump" => :optional

  def install
    virtualenv_install_with_resources
  end

  def caveats
    "To use post-processing options, `brew install ffmpeg` or `brew install libav`."
  end

  test do
    system bin/"you-get", "--info", "https://youtu.be/he2a4xK8ctk"
  end
end
