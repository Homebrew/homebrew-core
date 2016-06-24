class YouGet < Formula
  desc "Dumb downloader that scrapes the web"
  homepage "https://you-get.org/"
  url "https://github.com/soimort/you-get/archive/v0.4.455.tar.gz"
  sha256 "669e94790b55f19a00ad7d94e53b2dc8d86b34f6ff015041df6dfa8787acf369"
  head "https://github.com/soimort/you-get.git", :branch => "develop"

  bottle do
    cellar :any_skip_relocation
    sha256 "5ed39d4f8713b15adbf5e9c5fc924c233cd54496825f5572f3c5b0ce268e8e2d" => :el_capitan
    sha256 "24541ff856125b908adc764e91c475386fa4393010ddd5424b3a612847998844" => :yosemite
    sha256 "16f8a5779af418887f1c52899ddc16937d001ba70a4236798428a3e7e7220013" => :mavericks
  end

  depends_on :python3

  depends_on "rtmpdump" => :optional

  def install
    xy = Language::Python.major_minor_version "python3"
    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python#{xy}/site-packages"
    system "python3", *Language::Python.setup_install_args(libexec)

    bin.install Dir[libexec/"bin/*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  def caveats
    "To use post-processing options, `brew install ffmpeg` or `brew install libav`."
  end

  test do
    system "#{bin}/you-get", "--info", "https://www.youtube.com/watch?v=he2a4xK8ctk"
  end
end
