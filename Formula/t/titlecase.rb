class Titlecase < Formula
  desc "Script to convert text to title case"
  homepage "http://plasmasturm.org/code/titlecase/"
  url "https://github.com/ap/titlecase/archive/refs/tags/v1.005.tar.gz"
  sha256 "6483798bac1e359be4b3c48b8f710fd35cc4671dfe201322cbb3461a200b4f76"
  license "MIT"
  head "https://github.com/ap/titlecase.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "c1ff367e249007ca28d8cad714958e87b8fc938e6553dd19fb74d92edb860964"
  end

  def install
    bin.install "titlecase"
  end

  test do
    (testpath/"test").write "homebrew"
    assert_equal "Homebrew\n", shell_output("#{bin}/titlecase test")
  end
end
