class TrashCli < Formula
  include Language::Python::Virtualenv

  desc "Command-line interface to the freedesktop.org trashcan"
  homepage "https://github.com/andreafrancia/trash-cli"
  url "https://github.com/andreafrancia/trash-cli/archive/0.17.1.14.tar.gz"
  sha256 "8fdd20e5e9c55ea4e24677e602a06a94a93f1155f9970c55b25dede5e037b974"
  revision 3
  head "https://github.com/andreafrancia/trash-cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "5eed46cd5290cbb7db8ca2cd272e3334727f02e33d696bc7cdf161bdc1bbeb00" => :catalina
    sha256 "28570bf1d2f37d27ceac413d0dbfb191af1a764d42e543e1f7f102f63cf84ccf" => :mojave
    sha256 "c91899fb2e3eea76501cd3961abe8537e77eed264cf25b3a214a6123a37c6391" => :high_sierra
  end

  depends_on "python@3.8"

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
