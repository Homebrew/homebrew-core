class Titlecase < Formula
  desc "Script to convert text to title case"
  homepage "http://plasmasturm.org/code/titlecase/"
  url "https://github.com/ap/titlecase/archive/v1.005.tar.gz"
  sha256 "6483798bac1e359be4b3c48b8f710fd35cc4671dfe201322cbb3461a200b4f76"
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
