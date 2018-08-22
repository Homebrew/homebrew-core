class Titlecase < Formula
  desc "Script to convert text to title case"
  homepage "http://plasmasturm.org/code/titlecase/"
  url "https://github.com/ap/titlecase/archive/v1.004.tar.gz"
  sha256 "fbaafdb66ab4ba26f1f03fa292771d146c050fff0a3a640e11314ace322c2d92"
  head "https://github.com/ap/titlecase.git"

  bottle :unneeded

  def install
    bin.install "titlecase"
  end

  test do
    (testpath/"test").write "homebrew"
    assert_equal "Homebrew\n", shell_output("#{bin}/titlecase test")
  end
end
