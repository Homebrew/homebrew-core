class TrashCli < Formula
  include Language::Python::Virtualenv

  desc "Command-line interface to the freedesktop.org trashcan"
  homepage "https://github.com/andreafrancia/trash-cli"
  url "https://files.pythonhosted.org/packages/22/d1/0901ab1d04b296ea5a93d970299b1735b6e2bff49ea3c41bf910919be821/trash-cli-0.23.9.23.tar.gz"
  sha256 "d367f0a70b3b1c20d97bcb459c552eeefc42e7e8d00f2af334236708ec047584"
  license "GPL-2.0-or-later"
  head "https://github.com/andreafrancia/trash-cli.git", branch: "master"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "beeabce9224368639b46434a6f0ceea6e8dd02c2c036e1fe51b411dfa91fc44a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1f5b86d3ddf06b91acdb2350837d37964807c04c4404cceb1adafe12e29fcfca"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "06e5b9086edc8098f5d2885b01f8fdbbe724673d59fa5adba5e5d6a606d5ddce"
    sha256 cellar: :any_skip_relocation, sonoma:         "3b909b8ff91e5917f85d42cf6e53fe0b60c563e544c8243a724ad38ff5aea2b3"
    sha256 cellar: :any_skip_relocation, ventura:        "9cdd23d6ba6a2e030d070347827811484a50f3098301a87fbd5340498d8a0e9d"
    sha256 cellar: :any_skip_relocation, monterey:       "5e6f528b65ff88e5c65cdc54a514fdf3992ce3edcdfed4b6015ace4129b6e8df"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "842cb9c692cf8bd2993650612aec18461038226347bc98a2d3171fc54565d384"
  end

  depends_on "python-psutil"
  depends_on "python@3.12"
  depends_on "six"

  conflicts_with "macos-trash", because: "both install a `trash` binary"
  conflicts_with "trash", because: "both install a `trash` binary"

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
