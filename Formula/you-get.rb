class YouGet < Formula
  desc "Dumb downloader that scrapes the web"
  homepage "https://you-get.org/"
  url "https://github.com/soimort/you-get/archive/v0.4.424.tar.gz"
  sha256 "d664fa7d1da6878c9f3f673e64506ee9593b7677a27b3fdd0b6e994b0f87072d"
  head "https://github.com/soimort/you-get.git", :branch => "develop"

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
