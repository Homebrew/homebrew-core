class Rename < Formula
  desc "Perl-powered file rename script with many helpful built-ins"
  homepage "http://plasmasturm.org/code/rename"
  url "https://github.com/ap/rename/archive/v1.601.tar.gz"
  sha256 "e8fd67b662b9deddfb6a19853652306f8694d7959dfac15538a9b67339c87af4"
  head "https://github.com/ap/rename.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "5955aab33b5eb7ac76fb48870451f110caf8057cf76550bebf095f10fff38080" => :mojave
    sha256 "b40d758f416765733e0071705fae180c62c63058b350c379b9f36da9da98fad1" => :high_sierra
    sha256 "b40d758f416765733e0071705fae180c62c63058b350c379b9f36da9da98fad1" => :sierra
    sha256 "b40d758f416765733e0071705fae180c62c63058b350c379b9f36da9da98fad1" => :el_capitan
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
