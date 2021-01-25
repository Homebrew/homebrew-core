class Zpaq < Formula
  desc "Incremental, journaling command-line archiver"
  homepage "http://mattmahoney.net/dc/zpaq.html"
  url "http://mattmahoney.net/dc/zpaq715.zip"
  version "7.15"
  sha256 "e85ec2529eb0ba22ceaeabd461e55357ef099b80f61c14f377b429ea3d49d418"
  license "Unlicense"
  head "https://github.com/zpaq/zpaq.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "2a840dbf456e81e691300d615db206c1c046fe99746db13e41f972d6707c6a72" => :big_sur
    sha256 "5ac8de4997136cd5496e5480ce72421881da11cf0548cacbd2ed62b7e85dc0e5" => :catalina
    sha256 "572127bcc5ca3efba20c4f61c385dbf48873a241efd9349e0759d0ca14afb79d" => :mojave
  end

  resource "test" do
    url "http://mattmahoney.net/dc/calgarytest2.zpaq"
    sha256 "ad3b58c245b2a54136d3ff28be78c069b0272eb31f808bf82014134e5913cf7e"
  end

  def install
    system "make"
    system "make", "check"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    testpath.install resource("test")
    assert_match "all OK", shell_output("#{bin}/zpaq x calgarytest2.zpaq 2>&1")
  end
end
