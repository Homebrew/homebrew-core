class Udis86 < Formula
  desc "Minimalistic disassembler library for x86"
  homepage "http://udis86.sourceforge.net"
  url "https://downloads.sourceforge.net/udis86/udis86-1.7.2.tar.gz"
  sha256 "9c52ac626ac6f531e1d6828feaad7e797d0f3cce1e9f34ad4e84627022b3c2f4"

  bottle do
    cellar :any
    sha256 "e3774a825eda78db57585c75b739dc60d0c069e35c8666575f5889908b0735d5" => :sierra
    sha256 "e763db7beca50f11ab341f13f5fd571513f4847772bb70ef83d94bb576427673" => :el_capitan
    sha256 "bcd6eb347f55bc856ceb64604d3bace30219e346de34caa8be7de2b52a1cb35d" => :yosemite
    sha256 "84b56e3d62695b2c39c2c450d94fcd258439baedbcd68980a19b685f2e2b95c9" => :mavericks
  end

  option :universal

  def install
    ENV.universal_binary if build.universal?
    system "./configure", "--prefix=#{prefix}",
                          "--enable-shared"
    system "make"
    system "make", "install"
  end

  test do
    assert_match("int 0x80", pipe_output("#{bin}/udcli -x", "cd 80").split.last(2).join(" "))
  end
end
