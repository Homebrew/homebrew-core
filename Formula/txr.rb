class Txr < Formula
  desc "Original, new programming language for convenient data munging"
  homepage "https://www.nongnu.org/txr/"
  url "http://www.kylheku.com/cgit/txr/snapshot/txr-270.tar.bz2"
  sha256 "6e0fe840ee91430888a08db8ef7739b1884fa43e8b2b5e173e6ae3eda3150291"
  license "BSD-2-Clause"

  livecheck do
    url "http://www.kylheku.com/cgit/txr"
    regex(/href=.*?txr[._-]v?(\d+(?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "eed376b9bd8f3170f5f8722fc26c0d2be4d7edf65bbdf11f30ad825069813a0e"
    sha256 cellar: :any, big_sur:       "00950cb2c4a05f7f59ee5ad93f24d0ca409fda5ed186449be934e63668f0316d"
    sha256 cellar: :any, catalina:      "d8e8e17245b76c20dddc1950387ec6146f82e1af0045c1047eb51079e39f6b2e"
    sha256 cellar: :any, mojave:        "9eda256fe6c5fcbbafd9409c583595282a8909aaffed5d55525a08189117497b"
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
