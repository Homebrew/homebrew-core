class SfPwgen < Formula
  desc "Generate passwords using SecurityFoundation framework"
  homepage "https://github.com/anders/pwgen/"
  url "https://github.com/anders/pwgen/archive/1.5.tar.gz"
  sha256 "e1f1d575638f216c82c2d1e9b52181d1d43fd05e7169db1d6f9f5d8a2247b475"
  head "https://github.com/anders/pwgen.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "50e87a417ac3d9b5be7318c7e2983db1a1f90759fab02a898f9cd257b15ac6e2" => :mojave
    sha256 "2ebd137c58bd8d20a50251e159b6074e65009a265aa351cf6eb0afd39d59edc1" => :high_sierra
    sha256 "01cf1ff26d304c0cbb0072130ba2476ddeebd8933040092b937ced1ede06c2a2" => :sierra
  end

  def install
    system "make"
    bin.install "sf-pwgen"
  end

  test do
    assert_equal 20, shell_output("#{bin}/sf-pwgen -a memorable -c 1 -l 20").chomp.length
  end
end
