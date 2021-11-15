class Serd < Formula
  desc "C library for RDF syntax"
  homepage "https://drobilla.net/software/serd.html"
  url "https://download.drobilla.net/serd-0.30.10.tar.bz2"
  sha256 "affa80deec78921f86335e6fc3f18b80aefecf424f6a5755e9f2fa0eb0710edf"
  license "ISC"

  livecheck do
    url "https://download.drobilla.net/"
    regex(/href=.*?serd[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "b26e4ec50043872551439df4b6a1ce3ed3aa8c7341abc7dfa7d16bb63e0cd691"
    sha256 cellar: :any,                 arm64_big_sur:  "10155eb151924f5fea4d02b197a5e08c5536340d9335329ce9d3dd6af3431a11"
    sha256 cellar: :any,                 monterey:       "9c06d993a35acd352ea9623208e3618463d89ea3c99e5af04b6c07f60dd54700"
    sha256 cellar: :any,                 big_sur:        "e28a02ac86a643e66e2d98fb2e22089f58071bd27faba353494ddc92f6823bfb"
    sha256 cellar: :any,                 catalina:       "b9b49fee3a281d23119785510ce19337a2eb9fea637583291651a44b27b4f15f"
    sha256 cellar: :any,                 mojave:         "b780e951258475391de8618edc7915c5f10ea8286769537743d703ed51318778"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3845afc35cb30e10766ad72c7ebda66439f4a3a14de11b7441c5926930caa18e"
  end

  depends_on "pkg-config" => :build

  on_linux do
    depends_on "python@3.9" => :build
  end

  def install
    ENV.prepend_path "PATH", Formula["python@3.9"].opt_libexec/"bin" if OS.linux?
    system "./waf", "configure", "--prefix=#{prefix}"
    system "./waf"
    system "./waf", "install"
  end

  test do
    pipe_output("serdi -", "() a <http://example.org/List> .", 0)
  end
end
