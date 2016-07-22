class YouGet < Formula
  desc "Dumb downloader that scrapes the web"
  homepage "https://you-get.org/"
  url "https://github.com/soimort/you-get/archive/v0.4.486.tar.gz"
  sha256 "22002542c079ba049a8c2797700d07d5da2e22eb38eeb46ead19c28783855ca1"
  head "https://github.com/soimort/you-get.git", :branch => "develop"

  bottle do
    cellar :any_skip_relocation
    sha256 "b4d69de3f770f94f5ed25376cc7921739ff65c25cda4256f11cce9f71a7a65b4" => :el_capitan
    sha256 "dd03eacedc9ddd1d89e9884698d590932379538597cf81993d66269b714c1196" => :yosemite
    sha256 "20b17d758a0b76ecb24e15122f33127ab8d401f9023b7bcd7701d73375950076" => :mavericks
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
