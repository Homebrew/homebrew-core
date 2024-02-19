class Urlscan < Formula
  include Language::Python::Virtualenv

  desc "View/select the URLs in an email message or file"
  homepage "https://github.com/firecat53/urlscan"
  url "https://files.pythonhosted.org/packages/b7/7d/984994a32b261cc3a72d3bfb0b8c0de4f786682128dc659a5c5e02dfc48c/urlscan-1.0.1.tar.gz"
  sha256 "e0ec986e5aa2da57dd2face8692116d80af173d4eb56a78e4fd881731113307f"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "58abd0961d6cd3c5dfb45e0bb665573fc3d819e75ce824225f575e5584069b4c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2f3ac327ced320306b628a196e5feec94ab2202742bb785e620517cc06cdac61"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "44fb892524f6ec60ca56da2887e428211a562ed0a021f728d730949571cd25e8"
    sha256 cellar: :any_skip_relocation, sonoma:         "696105412b5246d755f08720c2c733dc320878ec0a92101f2c1906cf36ba28b8"
    sha256 cellar: :any_skip_relocation, ventura:        "e5354052fd940bbe2705ec05e00311d265ae406986cbbfedd4c41c0980e6c995"
    sha256 cellar: :any_skip_relocation, monterey:       "23e9cb821b7601fb8c211b5e17d85ae10e62ba445b8bbc9cde76641375f6338b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b1303d4b8e115058fe993501876848d9e7fa28c09e0208f387f674dd11a6ecd5"
  end

  depends_on "python@3.12"

  resource "urwid" do
    url "https://files.pythonhosted.org/packages/58/7e/4191aa9a1c4a7b2f73a7548002754863189217464fbf76045526c7c97be5/urwid-2.4.1.tar.gz"
    sha256 "6207cfa8ac911f251bbebf4d454a00e622f68bd5cd2c9e55b53c6eac85bb4a6f"
  end

  def install
    virtualenv_install_with_resources

    man1.install "urlscan.1"
  end

  test do
    output = pipe_output("#{bin}/urlscan -nc", "To:\n\nhttps://github.com/\nSome Text.\nhttps://brew.sh/")
    assert_equal "https://github.com/\nhttps://brew.sh/\n", output
  end
end
