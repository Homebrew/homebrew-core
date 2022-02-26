class Txr < Formula
  desc "Original, new programming language for convenient data munging"
  homepage "https://www.nongnu.org/txr/"
  url "http://www.kylheku.com/cgit/txr/snapshot/txr-274.tar.bz2"
  sha256 "6d6833d2498f2cdd15d2b9054620aac6406384df0557d7cbf95bbc192c3d25ae"
  license "BSD-2-Clause"

  livecheck do
    url "http://www.kylheku.com/cgit/txr"
    regex(/href=.*?txr[._-]v?(\d+(?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_monterey: "7b93bba38aed8c8d12efc1419fddda466a11cbf29f961778d85e713cb8751d42"
    sha256 cellar: :any, arm64_big_sur:  "be6af755e745f2f3d239e89a14e2ae7237783ff7b42e3d02a120f625925a4027"
    sha256 cellar: :any, monterey:       "6fb5423b9cff5be581d05d58f8f68dd8ce632c7740146e51d8ab29d013f21be8"
    sha256 cellar: :any, big_sur:        "3343e75170881a43edfadfff821ba93f6ad63dfb7eaeb8fb8731f5183baf1b62"
    sha256 cellar: :any, catalina:       "6cafa17c4ed4892449eb4fb1345e99477468295895926a2e61af8ce14c240d4d"
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
