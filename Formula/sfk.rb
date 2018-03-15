class Sfk < Formula
  desc "Command-line tools collection"
  homepage "http://stahlworks.com/dev/swiss-file-knife.html"
  url "https://downloads.sourceforge.net/project/swissfileknife/1-swissfileknife/1.9.0.2/sfk-1.9.0.tar.gz"
  version "1.9.0.2"
  sha256 "82e6b900578c24a83ea20f636ee12dce7565f98d53cbfd05f286e01467e0d2aa"

  bottle do
    cellar :any_skip_relocation
    sha256 "e03be10cd7374af2925ef43f34077207592ebd17fe0154599c900e276ba4bab9" => :high_sierra
    sha256 "e3071bbcfe4df4082ce6419b942c90caee261aff208089adf4ab847b55dcd144" => :sierra
    sha256 "2fdec7f1e4314c883deced2f12d4a84ebc7a6cf9e1454f41cda243bad948f9d9" => :el_capitan
  end

  def install
    ENV.libstdcxx

    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/sfk", "ip"
  end
end
