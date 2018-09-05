class Ren < Formula
  desc "Rename multiple files in a directory"
  homepage "http://pdb.finkproject.org/pdb/package.php/ren"
  url "https://www.ibiblio.org/pub/Linux/utils/file/ren-1.0.tar.gz"
  sha256 "6ccf51b473f07b2f463430015f2e956b63b1d9e1d8493a51f4ebd70f8a8136c9"

  bottle do
    cellar :any_skip_relocation
    sha256 "dd045987a704bd9690e5466337f7a55105c25c98807e430c74ad4b8702f4b292" => :mojave
    sha256 "7cf1fe07fb7a4cd0e6171f65a8fda8187973c879b8853e416c39282527f1c0ef" => :high_sierra
    sha256 "bf3e11211d6884d8969fc99ccf8a42b3132dc48bd3100492a442eb5a41fdbd88" => :sierra
    sha256 "966876dfcc9f36c4bc3d1358a9a8500c79d9324ebd8697033571146f1e482685" => :el_capitan
    sha256 "e8ca6bb656f8daca43c6ce446dfff66625fabdedda81604745f0960b419e422a" => :yosemite
    sha256 "c7be0857bfd182f310a700521b5989c36e98ea579a2cf14417d42aa4036448dd" => :mavericks
    sha256 "bb6418eeee84c36043dd035db66687f558821225ed41151bb7008a33090418bf" => :mountain_lion
  end

  def install
    system "make"
    bin.install "ren"
    man1.install "ren.1"
  end

  test do
    touch "test1.foo"
    touch "test2.foo"
    system bin/"ren", "*.foo", "#1.bar"
    assert_predicate testpath/"test1.bar", :exist?
    assert_predicate testpath/"test2.bar", :exist?
    refute_predicate testpath/"test1.foo", :exist?
    refute_predicate testpath/"test2.foo", :exist?
  end
end
