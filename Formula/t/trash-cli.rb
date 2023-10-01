class TrashCli < Formula
  include Language::Python::Virtualenv

  desc "Command-line interface to the freedesktop.org trashcan"
  homepage "https://github.com/andreafrancia/trash-cli"
  url "https://files.pythonhosted.org/packages/22/d1/0901ab1d04b296ea5a93d970299b1735b6e2bff49ea3c41bf910919be821/trash-cli-0.23.9.23.tar.gz"
  sha256 "d367f0a70b3b1c20d97bcb459c552eeefc42e7e8d00f2af334236708ec047584"
  license "GPL-2.0-or-later"
  head "https://github.com/andreafrancia/trash-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "43401ed349e19afa6a651f0e76dd22447de8eee4b24047ee9f53eeca7cf1fa85"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f7d1ec026acbd79807e3b461c27e7226a595b6a17ffcc5d9baf1f9d1ebbf7964"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fa37b58adc8ace3027b92219ad07fd99de428e0f9002c91b9403038f98c419f5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bb481500d369930d7f1bb9f7f8e785c8865d06e7d0759ebfde1d00c0218fc346"
    sha256 cellar: :any_skip_relocation, sonoma:         "8b9a694c7bef102fd3172bd1ca3778bb40ca79ce3de506638e6784b54490349d"
    sha256 cellar: :any_skip_relocation, ventura:        "1254f1309c742387d0efe032cfd15350ee40916f25788f7c73a71a7f3fda7bd5"
    sha256 cellar: :any_skip_relocation, monterey:       "e027eac6d5d625c2d9c27e1cf954bf86d648588c75fab3803a9dff84a7fdfccc"
    sha256 cellar: :any_skip_relocation, big_sur:        "0365e789e4a0a454b81388bee217ff7ad72029bd37cbe76fb446db182d0c996c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "58d352281618d62a2c6d20ced795fe9012b294fa821b03ceaf2adc7ee75dc9fd"
  end

  depends_on "python@3.11"
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
