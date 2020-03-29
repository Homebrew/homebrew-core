class Roswell < Formula
  desc "Lisp installer and launcher for major environments"
  homepage "https://github.com/roswell/roswell"
  url "https://github.com/roswell/roswell/archive/v20.01.14.104.tar.gz"
  sha256 "798b96fdcb8c89445b36692b31570bb99882d83719d6310d969ccfcb2a35a1d4"
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
