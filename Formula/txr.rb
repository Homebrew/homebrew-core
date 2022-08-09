class Txr < Formula
  desc "Original, new programming language for convenient data munging"
  homepage "https://www.nongnu.org/txr/"
  url "http://www.kylheku.com/cgit/txr/snapshot/txr-280.tar.bz2"
  sha256 "d62a967ab51e84b14f33add98c9618eb1a3da07a0d2bb9defdae8cdfee0be2ca"
  license "BSD-2-Clause"

  livecheck do
    url "http://www.kylheku.com/cgit/txr"
    regex(/href=.*?txr[._-]v?(\d+(?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_monterey: "73ab51f5c313dc2b99489b27af595682ad111a2eb29795b69b913ca758bfbabd"
    sha256 cellar: :any, arm64_big_sur:  "ea247a2c476dd0965508cd68218781a7e19fee5b4361b96117d712bba9f367e3"
    sha256 cellar: :any, monterey:       "003e8f9861ab941b231f4c266f1f6918882b6fc4c0c58c39d46a70b7e03a46b6"
    sha256 cellar: :any, big_sur:        "4ab450096900832fee3c1fcb18a8f2f9d7507f2a53a3be9860de808a31103aeb"
    sha256 cellar: :any, catalina:       "7860f2acb8b2cf24fa454d657cb77b8e245da61dd7b86c64ca50379e975af770"
  end

  depends_on "libffi"

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build

  def install
    system "./configure", "--prefix=#{prefix}", "--inline=static inline"
    system "make"
    system "make", "install"
  end

  test do
    assert_equal "3", shell_output(bin/"txr -p '(+ 1 2)'").chomp
  end
end
