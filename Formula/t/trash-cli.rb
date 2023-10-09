class TrashCli < Formula
  include Language::Python::Virtualenv

  desc "Command-line interface to the freedesktop.org trashcan"
  homepage "https://github.com/andreafrancia/trash-cli"
  url "https://files.pythonhosted.org/packages/22/d1/0901ab1d04b296ea5a93d970299b1735b6e2bff49ea3c41bf910919be821/trash-cli-0.23.9.23.tar.gz"
  sha256 "d367f0a70b3b1c20d97bcb459c552eeefc42e7e8d00f2af334236708ec047584"
  license "GPL-2.0-or-later"
  head "https://github.com/andreafrancia/trash-cli.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0f26710c762b515b1b5f06f5fea3d2ad047ec8f3f30911b1c2017bec99bd6503"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2a5896095a851eb653f643e2f1fd2f92c5d48d2462d3f0356f4bf6609876fa36"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3824d972f66e9fe95f96d51e96ac1994d6e5abb732487634b767fbcb07ff6d38"
    sha256 cellar: :any_skip_relocation, sonoma:         "6ef81a263b5acb8531c8a844270fcdc9a45debdb53bad319cfd1f468fe0c6979"
    sha256 cellar: :any_skip_relocation, ventura:        "af78e02492e60bf67fd771682bfe0374a468af1d57f49aacc005545894cacb6b"
    sha256 cellar: :any_skip_relocation, monterey:       "35a6b2ce827109653921992eb2d7db76d7dd3824e1ee97e92e12de63e0bf2f41"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a09f356d0a5b6ea767a4e5230584f47827aa6a0e9a0c1f0c4fae19a50eec97fd"
  end

  depends_on "python@3.12"
  depends_on "six"

  conflicts_with "macos-trash", because: "both install a `trash` binary"
  conflicts_with "trash", because: "both install a `trash` binary"

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/d6/0f/96b7309212a926c1448366e9ce69b081ea79d63265bde33f11cc9cfc2c07/psutil-5.9.5.tar.gz"
    sha256 "5410638e4df39c54d957fc51ce03048acd8e6d60abc0f5107af51e5fb566eb3c"
  end

  def install
    virtualenv_install_with_resources
    man1.install_symlink libexec.glob("share/man/man1/trash*.1")
  end

  test do
    touch "testfile"
    assert_predicate testpath/"testfile", :exist?
    system bin/"trash-put", "testfile"
    refute_predicate testpath/"testfile", :exist?
  end
end
