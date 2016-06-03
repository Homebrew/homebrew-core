class Traildb < Formula
  desc "Blazingly-fast database for log-structured data"
  homepage "http://traildb.io"
  url "https://github.com/traildb/traildb/archive/0.5.tar.gz"
  sha256 "4d1b61cc7068ec3313fe6322fc366a996c9d357dd3edf667dd33f0ab2c103271"

  depends_on "libarchive"
  depends_on "pkg-config" => :build

  resource "judy" do
    url "https://downloads.sourceforge.net/project/judy/judy/Judy-1.0.5/Judy-1.0.5.tar.gz"
    sha256 "d2704089f85fdb6f2cd7e77be21170ced4b4375c03ef1ad4cf1075bd414a63eb"
  end

  def install
    # We build judy as static library, so we don't need to install it
    # into the real prefix
    judyprefix = "#{buildpath}/resources/judy"

    resource("judy").stage do
      system "./configure", "--disable-debug", "--disable-dependency-tracking",
          "--disable-shared", "--prefix=#{judyprefix}"
      system "make", "-j1", "install"
    end

    ENV["PREFIX"] = prefix
    ENV.append "CFLAGS", "-I#{judyprefix}/include"
    ENV.append "LDFLAGS", "-L#{judyprefix}/lib"
    system "./waf", "configure", "install"
  end

  test do
    (testpath/"in.csv").write("1234 1234\n")
    system "#{bin}/tdb", "make", "-c", "-i", "in.csv", "--tdb-format", "pkg"
  end
end
