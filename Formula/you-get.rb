class YouGet < Formula
  include Language::Python::Virtualenv

  desc "Dumb downloader that scrapes the web"
  homepage "https://you-get.org/"
  url "https://github.com/soimort/you-get/releases/download/v0.4.715/you-get-0.4.715.tar.gz"
  sha256 "d0e6b5e16cc2c191bc6a3206098cf54fab625c687c86fbf55ace14e8a0106110"
  head "https://github.com/soimort/you-get.git", :branch => "develop"

  bottle do
    cellar :any_skip_relocation
    sha256 "ed50f2942e068afb0d6d285af61a384837c91f0aaaa285a81c72fde5dfb35759" => :sierra
    sha256 "2bf5144ecfd59e1d443033a7b6895c82ed90297be38a8c68eceff47ff3e53b45" => :el_capitan
    sha256 "d2b8ee88656fb5b0410292be99d9eea42d014541d3a82b173ff57eaba99e42ab" => :yosemite
  end

  depends_on :python3

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
