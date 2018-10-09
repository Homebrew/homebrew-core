class Roswell < Formula
  desc "Lisp installer and launcher for major environments"
  homepage "https://github.com/roswell/roswell"
  url "https://github.com/roswell/roswell/archive/v18.10.10.95.tar.gz"
  sha256 "9ad88ae0aed94feda679527f6ceb2732c39fd645921e91c048442be9874fff67"
  head "https://github.com/roswell/roswell.git"

  bottle do
    sha256 "10388dac3fa5ba87d04933c2450d5532bf559ff9b7a9238e309a982c63188465" => :mojave
    sha256 "61e6b9d970a32ac3e75906259f983e07abdf0e3bbee0187884ddf1c0832e0325" => :high_sierra
    sha256 "307a2b764504c25c34dacf23487014202ca0d7dfb8b212122e961eb2a200e5ad" => :sierra
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
