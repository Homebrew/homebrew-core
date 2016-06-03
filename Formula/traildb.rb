class Traildb < Formula
  desc "Blazingly-fast database for log-structured data"
  homepage "http://traildb.io"
  url "https://github.com/traildb/traildb/archive/0.5.tar.gz"
  sha256 "4d1b61cc7068ec3313fe6322fc366a996c9d357dd3edf667dd33f0ab2c103271"

  depends_on "libarchive"
  depends_on "homebrew/boneyard/judy"
  depends_on "pkg-config" => :build

  def install
    ENV["PREFIX"] = prefix
    system "./waf", "configure", "install"
  end

  test do
    (testpath/"in.csv").write("1234 1234\n")
    system "#{bin}/tdb", "make", "-c", "-i", "in.csv", "--tdb-format", "pkg"
  end
end
