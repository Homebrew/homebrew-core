class Tth < Formula
  desc "TeX/LaTeX to HTML converter"
  homepage "http://hutchinson.belmont.ma.us/tth/"
  url "http://hutchinson.belmont.ma.us/tth/tth_distribution/tth_4.16.tgz"
  sha256 "ff8b88c6dbb938f01fe6a224c396fc302ae5d89b9b6d97f207f7ae0c4e7f0a32"

  livecheck do
    url "http://hutchinson.belmont.ma.us/tth/Version"
    regex(/"v?(\d+(?:\.\d+)+)"/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fdeb38cd3835c63253e57a04f574b8ecf27ff68c27fd990f65eaa390cea3261f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4a80f7935ebe70d616800844afada0ab97f6d9f6ef0ab486dd2905444692e0df"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cebda67056a4417f92be161280b8cc077db34fac85cbfa5e4a660b0620913263"
    sha256 cellar: :any_skip_relocation, monterey:       "8412801643019ab0fbd7642b63a165e895b86ab590ee41a9a4477cd27913f059"
    sha256 cellar: :any_skip_relocation, big_sur:        "f7e6b2ec14f714eba733cc395c3bc9f2508834a8b26d8d3f67d973ee10a43d2d"
    sha256 cellar: :any_skip_relocation, catalina:       "3e3902e915b07ebd6527c8ae2dd755b9134c97ff0efad473803ed8cca06f5a08"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c446bed3720c8c0492ecf875b8b14069e32d593b887ba5ccd956dc604e4a913e"
  end

  def install
    system ENV.cc, "-o", "tth", "tth.c"
    bin.install %w[tth latex2gif ps2gif ps2png]
    man1.install "tth.1"
  end

  test do
    assert_match(/version #{version}/, pipe_output("#{bin}/tth", ""))
  end
end
