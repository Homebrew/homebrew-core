class Ssocr < Formula
  desc "Seven Segment Optical Character Recognition"
  homepage "https://www.unix-ag.uni-kl.de/~auerswal/ssocr/"
  url "https://www.unix-ag.uni-kl.de/~auerswal/ssocr/ssocr-2.24.1.tar.bz2"
  sha256 "563adcd6fe807c1cf55e4ec52d58dc5af5b8ccd787af7cb9568eeb7a71ae3d5c"
  license "GPL-3.0-or-later"
  head "https://github.com/auerswal/ssocr.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "a1b3877af316686626fc798ea243b24657fb1b0468e3e6bc10c9199fbfbd64b7"
    sha256 cellar: :any,                 arm64_sonoma:  "0e8e16f17874e0fee5bf2c9d1d793e5713f421c90845ebdac1be6b24043e7a6e"
    sha256 cellar: :any,                 arm64_ventura: "29b908f4c7eba25b62c1db223308e94220189fc4b4f1f8f15b89a1d81045dd61"
    sha256 cellar: :any,                 sonoma:        "035a63886c348ffa8db1375f256dede76cac864b375ab82f8fffca2710e5a3fa"
    sha256 cellar: :any,                 ventura:       "977c33305dc392f8c75e46b3933542c90dcdb31b75fc56cbf1d9661097cc7b93"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1ba0b6c92964518ff2df9082e0295a0f3e69c8171f988ed7e8345a47bf25e1ee"
  end

  depends_on "pkgconf" => :build
  depends_on "imlib2"

  resource "homebrew-test-image" do
    url "https://www.unix-ag.uni-kl.de/~auerswal/ssocr/six_digits.png"
    sha256 "72b416cca7e98f97be56221e7d1a1129fc08d8ab15ec95884a5db6f00b2184f5"
  end

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    resource("homebrew-test-image").stage testpath
    assert_equal "431432", shell_output("#{bin}/ssocr -T #{testpath}/six_digits.png").chomp
  end
end
