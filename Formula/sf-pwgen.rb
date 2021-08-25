class SfPwgen < Formula
  desc "Generate passwords using SecurityFoundation framework"
  homepage "https://github.com/anders/pwgen/"
  url "https://github.com/anders/pwgen/archive/1.5.tar.gz"
  sha256 "e1f1d575638f216c82c2d1e9b52181d1d43fd05e7169db1d6f9f5d8a2247b475"
  license "Zlib"
  head "https://github.com/anders/pwgen.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "0f425de9f8e3e82e24a4c10143e54006c96e6063a19fb64643ec0b3ce279cdaa"
    sha256 cellar: :any_skip_relocation, big_sur:       "bcf403285094f1c803d9f8884aff19225ea5d7ab45329d6efc232f468e43b4c2"
    sha256 cellar: :any_skip_relocation, catalina:      "0fc934513e71330c48333b6e0698b39013d1b2aee57f93124c0c1bff2236475e"
    sha256 cellar: :any_skip_relocation, mojave:        "50e87a417ac3d9b5be7318c7e2983db1a1f90759fab02a898f9cd257b15ac6e2"
    sha256 cellar: :any_skip_relocation, high_sierra:   "2ebd137c58bd8d20a50251e159b6074e65009a265aa351cf6eb0afd39d59edc1"
    sha256 cellar: :any_skip_relocation, sierra:        "01cf1ff26d304c0cbb0072130ba2476ddeebd8933040092b937ced1ede06c2a2"
  end

  def install
    system "make"
    bin.install "sf-pwgen"
  end

  test do
    assert_equal 20, shell_output("#{bin}/sf-pwgen -a memorable -c 1 -l 20").chomp.length
  end
end
