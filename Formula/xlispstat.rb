class Xlispstat < Formula
  desc "Statistical data science environment based on Lisp"
  homepage "https://homepage.stat.uiowa.edu/~luke/xls/xlsinfo/"
  url "https://homepage.cs.uiowa.edu/~luke/xls/xlispstat/current/xlispstat-3-52-23.tar.gz"
  version "3.52.23"
  sha256 "9bf165eb3f92384373dab34f9a56ec8455ff9e2bf7dff6485e807767e6ce6cf4"

  bottle do
    cellar :any_skip_relocation
    sha256 "0180be9b973a87ff7feb72dbaebed8a46f857e1f670e864276e43cc294515870" => :sierra
    sha256 "f83a1cc043c82daf6bf4fa9717f090e10e04388544d79771ce8b6848c880b757" => :el_capitan
    sha256 "c4004c8fc128a187c35923eff3cb0c5a641f7928aff558559279d5d98abe849d" => :yosemite
  end

  depends_on :x11

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    ENV.j1 # Or make fails bytecompiling lisp code
    system "make"
    system "make", "install"
  end

  test do
    assert_equal "> 50.5\n> ", pipe_output("#{bin}/xlispstat | tail -2", "(median (iseq 1 100))")
  end
end
