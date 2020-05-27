class Tth < Formula
  desc "TeX/LaTeX to HTML converter"
  homepage "http://hutchinson.belmont.ma.us/tth/"
  url "http://hutchinson.belmont.ma.us/tth/tth_distribution/tth_4.13.tgz"
  sha256 "1fa2bb7200c85d7f018d0ac64cc4bc73df94e6668d545378a1990f2abac52ae6"

  bottle do
    cellar :any_skip_relocation
    sha256 "ee1d635ae810913a1a1651452f4d3f94249f2c757353ae3d34bdc17404dc81e5" => :catalina
    sha256 "04da16c55583ce0eb533ec931475fb1e7af82cf028bdbb458515f0cf9984ff74" => :mojave
    sha256 "76384c1ea48529e728ff50998b0d6bb4d9fbe920ed75cb4bfb9ee1da6309421b" => :high_sierra
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
