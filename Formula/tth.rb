class Tth < Formula
  desc "TeX/LaTeX to HTML converter"
  homepage "http://hutchinson.belmont.ma.us/tth/"
  url "http://hutchinson.belmont.ma.us/tth/tth_distribution/tth_4.09.tgz"
  sha256 "c16f4f2bdbc8c2c829eaab073982bb2594f72ff4e752cd4c4dc2220a4a69772c"

  bottle do
    cellar :any_skip_relocation
    sha256 "aaa6ac8618c8e71bf7975e0f8c81f7c7c8c70888cb60753f23d563dac7465006" => :sierra
    sha256 "7c8b17cd1cefc82928697908e773e4ad0f7179ba8b2b3adeef42b6a3e28eb21e" => :el_capitan
    sha256 "d4f98342a0ad8edbbe8e740e2184626e32e88121ab68884c0e2902041257ce70" => :yosemite
    sha256 "fc85ad1d9985b45fbfbae6d2016c985ac9531a7a88c41f199c8386be414d5519" => :mavericks
    sha256 "81727008272c27d31ab334641f47049b07a9be6240efd9d5e02fa386e515008b" => :mountain_lion
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
