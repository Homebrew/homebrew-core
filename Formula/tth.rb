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
    sha256 "9f8333051d4b9025641302175bac6db82a883dc722c8dd8286a424af16cab3a1" => :big_sur
    sha256 "087ea392bb9b6de0921381bbf9b635e5dfe6e6c2d75e00e2143d5b6506e6cb14" => :arm64_big_sur
    sha256 "eba438c9ec2902578cd3a043fdfbc1fa6bf22bedbde36e868c4fe02740448b06" => :catalina
    sha256 "a0fcd3029a8a43a59a530537c5fef4df45c0155924f41b07ac14ec2362d73ba7" => :mojave
    sha256 "dc8224b651a9bbb3ab8a5f5dd2e213bfd42518962bd7132cb3d8a2db12ddd5bb" => :high_sierra
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
