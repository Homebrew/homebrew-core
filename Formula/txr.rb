class Txr < Formula
  desc "Original, new programming language for convenient data munging"
  homepage "https://www.nongnu.org/txr/"
  url "http://www.kylheku.com/cgit/txr/snapshot/txr-258.tar.bz2"
  sha256 "05cf3384afc3a49b0dbec8a652334119502b86f638d19494268f86dd0d52c8b7"
  license "BSD-2-Clause"

  livecheck do
    url "http://www.kylheku.com/cgit/txr"
    regex(/href=.*?txr[._-]v?(\d+(?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "340d00a43e6f309d9935842eb2aa4831ea5e9b0bd28c70a995d7a499c4a051a7"
    sha256 cellar: :any, big_sur:       "37ec0851dbca702de6083fa92eb45505db47a364130ea7d3d7d65efd2eb605dc"
    sha256 cellar: :any, catalina:      "47235ccf45a2083198bfc4e5e224247397556a7f744b0c4af9b9900fe6050090"
    sha256 cellar: :any, mojave:        "3cba32d0cf9c3711273c295e8e3b942a89e80e509da86fa7af039d046659da6a"
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
