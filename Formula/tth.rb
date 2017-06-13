class Tth < Formula
  desc "TeX/LaTeX to HTML converter"
  homepage "http://hutchinson.belmont.ma.us/tth/"
  url "http://hutchinson.belmont.ma.us/tth/tth_distribution/tth_4.09.tgz"
  sha256 "c16f4f2bdbc8c2c829eaab073982bb2594f72ff4e752cd4c4dc2220a4a69772c"

  bottle do
    cellar :any_skip_relocation
    sha256 "9f3771daa6780c062624717bd4ccf921267b2318781f86ed26ad213a3eb3b273" => :sierra
    sha256 "eb5c7de0bb431b91b4e2cb2d131ef6d0e9d8f4c7bd22dfc11d97078649413afb" => :el_capitan
    sha256 "ebd874131b52829584cf26db15f6199c133a3cf96b90e5a71985c4bac298f7ba" => :yosemite
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
