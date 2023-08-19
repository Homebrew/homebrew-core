class Titlecase < Formula
  desc "Script to convert text to title case"
  homepage "http://plasmasturm.org/code/titlecase/"
  url "https://github.com/ap/titlecase/archive/v1.005.tar.gz"
  sha256 "6483798bac1e359be4b3c48b8f710fd35cc4671dfe201322cbb3461a200b4f76"
  license "MIT"
  head "https://github.com/ap/titlecase.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "016d29b351920229fead9d3b8ac962522ff95f52dbfa711ba0867cc10d0d762c"
  end

  def install
    bin.install "titlecase"
  end

  test do
    (testpath/"test").write "homebrew"
    assert_equal "Homebrew\n", shell_output("#{bin}/titlecase test")
  end
end
