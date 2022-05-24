class Toot < Formula
  include Language::Python::Virtualenv
  desc "Mastodon CLI & TUI"
  homepage "https://toot.readthedocs.io/en/latest/index.html"
  url "https://files.pythonhosted.org/packages/0f/80/189d52bc7d4be7a9140780281bad0d58537ab42c4ce641645b04ec305013/toot-0.28.0.tar.gz"
  sha256 "690250e975c58f962cf33aefbe5b871dc6ea934580cec7f5b6a18e0f4c2052f3"
  license "GPL-3.0-only"
  revision 1
  head "https://github.com/ihabunek/toot.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "25d53914e2c227fadedaf57d0e24bcae4c58b004d1d0b03df530206614faa0d7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "62d5912626349abfae174e9aa089b6b1a9d39f810ead9037d1e1eb28f5037cb6"
    sha256 cellar: :any_skip_relocation, monterey:       "1873981ae3a93bc2c5e6340bc0ba4ceb3949d816956efa9b8da2b63cc8c5abb0"
    sha256 cellar: :any_skip_relocation, big_sur:        "5a9aa6a2791e1e77d0e6a7d0cd3e80c090ad61d274b73ecc25adbf171d8a240b"
    sha256 cellar: :any_skip_relocation, catalina:       "6baa50b0758d2fb5ef2c3e1def6555830bc07e8c4942572650621814bb333f68"
    sha256 cellar: :any_skip_relocation, mojave:         "7bde3bb494bdda10977f62bf1439e2b0bbf540a789ea4b86fd7df6f677c215e4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9a6e9cce4884cbe8b3eaf1004fac0e8160bd52bce48179096c949577bd0df14c"
  end

  depends_on "python@3.10"

  resource "beautifulsoup4" do
    url "https://files.pythonhosted.org/packages/a1/69/daeee6d8f22c997e522cdbeb59641c4d31ab120aba0f2c799500f7456b7e/beautifulsoup4-4.10.0.tar.gz"
    sha256 "c23ad23c521d818955a4151a67d81580319d4bf548d3d49f4223ae041ff98891"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/6d/78/f8db8d57f520a54f0b8a438319c342c61c22759d8f9a1cd2e2180b5e5ea9/certifi-2021.5.30.tar.gz"
    sha256 "2bbf76fd432960138b3ef6dda3dde0544f27cbf8546c458e60baf371917ba9ee"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/eb/7f/a6c278746ddbd7094b019b08d1b2187101b1f596f35f81dc27f57d8fcf7c/charset-normalizer-2.0.6.tar.gz"
    sha256 "5ec46d183433dcbd0ab716f2d7f29d8dee50505b3fdb40c6b985c7c4f5a3591f"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/cb/38/4c4d00ddfa48abe616d7e572e02a04273603db446975ab46bbcd36552005/idna-3.2.tar.gz"
    sha256 "467fbad99067910785144ce333826c71fb0e63a425657295239737f7ecd125f3"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/e7/01/3569e0b535fb2e4a6c384bdbed00c55b9d78b5084e0fb7f4d0bf523d7670/requests-2.26.0.tar.gz"
    sha256 "b8aa58f8cf793ffd8782d3d8cb19e66ef36f7aba4353eec859e74678b01b07a7"
  end

  resource "soupsieve" do
    url "https://files.pythonhosted.org/packages/c8/3f/e71d92e90771ac2d69986aa0e81cf0dfda6271e8483698f4847b861dd449/soupsieve-2.2.1.tar.gz"
    sha256 "052774848f448cf19c7e959adf5566904d525f33a3f8b6ba6f6f8f26ec7de0cc"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/80/be/3ee43b6c5757cabea19e75b8f46eaf05a2f5144107d7db48c7cf3a864f73/urllib3-1.26.7.tar.gz"
    sha256 "4987c65554f7a2dbf30c18fd48778ef124af6fab771a377103da0585e2336ece"
  end

  resource "urwid" do
    url "https://files.pythonhosted.org/packages/94/3f/e3010f4a11c08a5690540f7ebd0b0d251cc8a456895b7e49be201f73540c/urwid-2.1.2.tar.gz"
    sha256 "588bee9c1cb208d0906a9f73c613d2bd32c3ed3702012f51efe318a3f2127eae"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/89/38/459b727c381504f361832b9e5ace19966de1a235d73cdbdea91c771a1155/wcwidth-0.2.5.tar.gz"
    sha256 "c4d647b99872929fdb7bdcaa4fbe7f01413ed3d98077df798530e5b04f116c83"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/toot")
    assert_match "You are not logged in to any accounts", shell_output("#{bin}/toot auth")
  end
end
