class Smu < Formula
  desc "Simple markup with markdown-like syntax"
  homepage "https://github.com/Gottox/smu"
  url "https://github.com/Gottox/smu/archive/v1.5.tar.gz"
  sha256 "f3bb18f958962679a7fb48d7f8dcab8b59154d66f23c9aba02e78103106093a4"
  license "MIT"
  head "https://github.com/Gottox/smu.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "35080edb3d9aebd3207eaf70a786cd1edd5676a1d6ad579ce79c8bbd355c2bb9"
    sha256 cellar: :any_skip_relocation, big_sur:       "a6e6dd62afe5ec17b79c60a9c4e2b7a1336c3557419c1e154d61496290c46dc2"
    sha256 cellar: :any_skip_relocation, catalina:      "3b5b9f0dbb95b72dc55a17a7966db232bf0b54d9b7b6fbf85a8fef44054ffc6a"
    sha256 cellar: :any_skip_relocation, mojave:        "081239f69508758aceb226f12d06548fe555cb36c3e36258e92566ed21b08195"
  end

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    (testpath/"test.md").write "[Homebrew](https://brew.sh)"
    assert_equal "<p><a href=\"https://brew.sh\">Homebrew</a></p>\n", shell_output("#{bin}/smu test.md")
  end
end
