class Roswell < Formula
  desc "Lisp installer and launcher for major environments"
  homepage "https://github.com/roswell/roswell"
  url "https://github.com/roswell/roswell/archive/v19.08.10.101.tar.gz"
  sha256 "0f80277ac1609b8865c54856130d9fd7e8f099988e720367f6ef6448cd47b2b6"
  head "https://github.com/roswell/roswell.git"

  bottle do
    sha256 "7845a692e70e1e730ca28d006d28d0d820e1dda17822173678cb8953355fa652" => :mojave
    sha256 "8f6679b2029c370f542347b85dfc2064891cba533ce4f00f1251eb5aa1a7a630" => :high_sierra
    sha256 "bd03edaabed64ba841d312fc8ed9fa34c914e701eda75da671d3ab81f8b79233" => :sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build

  def install
    system "./bootstrap"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    ENV["ROSWELL_HOME"] = testpath
    system bin/"ros", "init"
    assert_predicate testpath/"config", :exist?
  end
end
