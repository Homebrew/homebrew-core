class Rename < Formula
  desc "Perl-powered file rename script with many helpful built-ins"
  homepage "http://plasmasturm.org/code/rename"
  url "https://github.com/ap/rename/archive/v1.601.tar.gz"
  sha256 "e8fd67b662b9deddfb6a19853652306f8694d7959dfac15538a9b67339c87af4"
  head "https://github.com/ap/rename.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "494aba9267348e401431cbcb1193df1c1138fda69d66aaa3c7ee229be51277fd" => :catalina
    sha256 "13c919a8edd4935b7e5462a172b8336c0425a627f76fd3aa72c652c35ea233cc" => :mojave
    sha256 "86b4b8a450b749f6fd84d86334d2d9f3a1c57fa3832f6e69d602369b4c6e5300" => :high_sierra
    sha256 "ed4a9403e533b143f8f1ee307035b28c995a13970c64ed7646719e12688ec7a0" => :sierra
  end

  conflicts_with "util-linux", :because => "both install `rename` binaries"

  def install
    system "pod2man", "rename", "rename.1"
    bin.install "rename"
    man1.install "rename.1"
  end

  test do
    touch "foo.doc"
    system "#{bin}/rename -s .doc .txt *.d*"
    refute_predicate testpath/"foo.doc", :exist?
    assert_predicate testpath/"foo.txt", :exist?
  end
end
