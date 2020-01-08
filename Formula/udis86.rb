class Udis86 < Formula
  desc "Minimalistic disassembler library for x86"
  homepage "https://udis86.sourceforge.io"
  url "https://downloads.sourceforge.net/udis86/udis86-1.7.2.tar.gz"
  sha256 "9c52ac626ac6f531e1d6828feaad7e797d0f3cce1e9f34ad4e84627022b3c2f4"

  bottle do
    cellar :any
    sha256 "28f761b215237ed656359cce94fd4787be86a50057dc064589f6bbedbcf2fe06" => :catalina
    sha256 "b510a8349883e86135cf030953df54b671cf668a1e3e5020fc059a0f6f92a52d" => :mojave
    sha256 "cefad0043918886a862a040adf2450699c00cbef3fd561bbc8867e2328b16ac8" => :high_sierra
    sha256 "e3774a825eda78db57585c75b739dc60d0c069e35c8666575f5889908b0735d5" => :sierra
    sha256 "e763db7beca50f11ab341f13f5fd571513f4847772bb70ef83d94bb576427673" => :el_capitan
    sha256 "bcd6eb347f55bc856ceb64604d3bace30219e346de34caa8be7de2b52a1cb35d" => :yosemite
    sha256 "84b56e3d62695b2c39c2c450d94fcd258439baedbcd68980a19b685f2e2b95c9" => :mavericks
  end

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--enable-shared"
    system "make"
    system "make", "install"
  end

  test do
    assert_match("int 0x80", pipe_output("#{bin}/udcli -x", "cd 80").split.last(2).join(" "))
  end
end
