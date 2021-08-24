class Titlecase < Formula
  desc "Script to convert text to title case"
  homepage "http://plasmasturm.org/code/titlecase/"
  url "https://github.com/ap/titlecase/archive/v1.004.tar.gz"
  sha256 "fbaafdb66ab4ba26f1f03fa292771d146c050fff0a3a640e11314ace322c2d92"
  license "MIT"
  head "https://github.com/ap/titlecase.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "27a6bbb0ade7749f3ac3f72871f7f9f611a61e8af02046511d33f723881fba0d"
  end

  def install
    bin.install "titlecase"
  end

  test do
    (testpath/"test").write "homebrew"
    assert_equal "Homebrew\n", shell_output("#{bin}/titlecase test")
  end
end
