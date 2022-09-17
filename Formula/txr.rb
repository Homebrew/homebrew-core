class Txr < Formula
  desc "Lisp-like programming language for convenient data munging"
  homepage "https://www.nongnu.org/txr/"
  url "http://www.kylheku.com/cgit/txr/snapshot/txr-282.tar.bz2"
  sha256 "5f10467610d8213be9af8a1fc9dafbd4902b7b473a82d8b2945cfa5ea6d2fee5"
  license "BSD-2-Clause"

  livecheck do
    url "http://www.kylheku.com/cgit/txr"
    regex(/href=.*?txr[._-]v?(\d+(?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3770324c3c26ca4c2f487d208e0e73beeca8d32cce8f329b962df0d87c2c9331"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5dbce6d648a73417efd9d0212316f0b8c3f5d1140f93f69df6acc5c5adc39180"
    sha256 cellar: :any_skip_relocation, monterey:       "bc7b985bc3a2d51fd7afcfc85264659ff181afcc95ef4851b948cc79253c392d"
    sha256 cellar: :any_skip_relocation, big_sur:        "bf0443268662f009d7d81db2e86e9281deb369f99c033b77847efd1320552a28"
    sha256 cellar: :any_skip_relocation, catalina:       "87399c2bdb2f7231d2a7ad9e39374f980eeff9955481578cce1e6ddf93764cf7"
  end

  depends_on "pkg-config" => :build
  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build
  uses_from_macos "libffi", since: :catalina

  def install
    system "./configure", "--prefix=#{prefix}", "--inline=static inline"
    system "make"
    system "make", "install"
  end

  test do
    assert_equal "3", shell_output("#{bin}/txr -p '(+ 1 2)'").chomp
  end
end
