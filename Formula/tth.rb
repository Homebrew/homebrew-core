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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f37a1410128cc821a0d786a3e016010537191a31dd6d04bc0e38a1d924d5f2ba"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "087ea392bb9b6de0921381bbf9b635e5dfe6e6c2d75e00e2143d5b6506e6cb14"
    sha256 cellar: :any_skip_relocation, monterey:       "fcc42fa0ad0c88c57b2659ec16959520824e7fff9573c744cd4642aa105b74c8"
    sha256 cellar: :any_skip_relocation, big_sur:        "9f8333051d4b9025641302175bac6db82a883dc722c8dd8286a424af16cab3a1"
    sha256 cellar: :any_skip_relocation, catalina:       "eba438c9ec2902578cd3a043fdfbc1fa6bf22bedbde36e868c4fe02740448b06"
    sha256 cellar: :any_skip_relocation, mojave:         "a0fcd3029a8a43a59a530537c5fef4df45c0155924f41b07ac14ec2362d73ba7"
    sha256 cellar: :any_skip_relocation, high_sierra:    "dc8224b651a9bbb3ab8a5f5dd2e213bfd42518962bd7132cb3d8a2db12ddd5bb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fa2cdf102a31eaee0fe9a64f9d5e0db28fc5284b02f0d005c2d91d473a574514"
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
