class TrashCli < Formula
  include Language::Python::Virtualenv

  desc "Command-line interface to the freedesktop.org trashcan"
  homepage "https://github.com/andreafrancia/trash-cli"
  url "https://github.com/andreafrancia/trash-cli/archive/0.17.1.14.tar.gz"
  sha256 "8fdd20e5e9c55ea4e24677e602a06a94a93f1155f9970c55b25dede5e037b974"
  revision 1
  head "https://github.com/andreafrancia/trash-cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "6fafad8c264d9c9a12f2346998a39e7407a0fef9713b5aa98541af27be124ca2" => :catalina
    sha256 "63895ceb716e9cd3b45bc9dd676afbb973c49f82cf11445aca89ef3cc1e3da69" => :mojave
    sha256 "c4d324ed98f547cad585e0eaa348c7e8b26e9036c77ab7bbfcc856d76c1ddeb4" => :high_sierra
    sha256 "5cb6346603e9ba432c92d46bc20f8612dad0dfa4e32e1996e2c0cc1aaab87990" => :sierra
  end

  depends_on "python"

  conflicts_with "trash", :because => "both install a `trash` binary"

  def install
    virtualenv_install_with_resources
  end

  test do
    touch "testfile"
    assert_predicate testpath/"testfile", :exist?
    system bin/"trash-put", "testfile"
    refute_predicate testpath/"testfile", :exist?
  end
end
