class Roswell < Formula
  desc "Lisp installer and launcher for major environments"
  homepage "https://github.com/roswell/roswell"
  url "https://github.com/roswell/roswell/archive/v20.06.14.107.tar.gz"
  sha256 "fc3fd46c55a50e2b76aba60ebbfeab393f345cdca7f2a87a6772c8b4fce3c2e4"
  license "MIT"
  head "https://github.com/roswell/roswell.git"

  bottle do
    sha256 "dcd9cf15c21d13724f36fd736529faba40dc0c2af2008c970b94049796d6d171" => :catalina
    sha256 "2d28ef4f1a1cbf94fba0132f7e1f05abb87854af6ce65f70c71877c7152d5622" => :mojave
    sha256 "a6d5d3ddafc4afefbb84d077b2157a1e7101c5c057bc7fe25714c19b83659017" => :high_sierra
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
