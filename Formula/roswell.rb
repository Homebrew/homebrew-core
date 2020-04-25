class Roswell < Formula
  desc "Lisp installer and launcher for major environments"
  homepage "https://github.com/roswell/roswell"
  url "https://github.com/roswell/roswell/archive/v20.04.14.105.tar.gz"
  sha256 "27db6a31e62c6ce03b2ccc846cbc572c84f85b1dc32f5d440b41f3d148f57d56"
  head "https://github.com/roswell/roswell.git"

  bottle do
    sha256 "cfc2b1162cb943801344f8938873b8717095f045300ccd42eeb4f649197a949e" => :catalina
    sha256 "92a71c326eaf2dbfee8da1579d85dae1d181d538b65c3b1757cb632267d92fa2" => :mojave
    sha256 "f68424fef64462de12fbed01d0380655887a505f7b1f3f4c633649749ffaea1a" => :high_sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build

  uses_from_macos "curl"

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
