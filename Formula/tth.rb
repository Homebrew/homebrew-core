class Tth < Formula
  desc "TeX/LaTeX to HTML converter"
  homepage "http://hutchinson.belmont.ma.us/tth/"
  url "http://hutchinson.belmont.ma.us/tth/tth_distribution/tth_4.15.tgz"
  sha256 "83c1f39fbf3377fb43e3d01d042302fa91f8758aa9acc10e22fe8af140f0126c"

  livecheck do
    url "http://hutchinson.belmont.ma.us/tth/Version"
    regex(/"v?(\d+(?:\.\d+)+)"/i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "795276a9b4c2cdf1373585d536d7df254966ecc16463b0f5579465cf76a052c8" => :catalina
    sha256 "9a6621aa12fee28e032ed5c73d5e385ac20249d9ef6714581a7cb3608f4490c5" => :mojave
    sha256 "c73b8efe4532752cb6ae1c524c3988e3d105e60456b7aa0ba0b77dc1da06b669" => :high_sierra
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
