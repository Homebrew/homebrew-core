class Toot < Formula
  include Language::Python::Virtualenv

  desc "Mastodon CLI & TUI"
  homepage "https://toot.readthedocs.io/en/latest/index.html"
  url "https://files.pythonhosted.org/packages/88/c8/5690de8955f4e0f0768cfa9add0b3630e77eab55db8537f5ab65e9f3cf01/toot-0.30.1.tar.gz"
  sha256 "bfabdfcbd8a78e9597f5f01e6dae171b2478553503d2c4cc66b33b4eb3132e65"
  license "GPL-3.0-only"
  head "https://github.com/ihabunek/toot.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "049efbf5640e30ce46a5215317e1d6d1e6874a5e2adab3cac4d86816273c31ad"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5354e3dfeeb2f290a1a2789f934c87ff889c90a8ac3d0bb947cb36de559f4aed"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4f0135856502abc5d235425b7d4e29663554d8ef77060ed050bf1d609fce6126"
    sha256 cellar: :any_skip_relocation, ventura:        "0744c9c69327d71e2b3711bfd884d5514bb367c44620078320e6bc264851d544"
    sha256 cellar: :any_skip_relocation, monterey:       "ee893650eb52228647951e27a33cb0cbc469c163a4377c841b3ee3517a175a0d"
    sha256 cellar: :any_skip_relocation, big_sur:        "f0dfebe16cb54ff6cfdc81a2d121c175dd28cbc933c3e17586ef2c18d85ba6ed"
    sha256 cellar: :any_skip_relocation, catalina:       "3215dabd34426d69fbe70ddd5d7130c1ef284c856bb6df1c20ec37ea1fef4eac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f77acffb789cad0ba5edf29bedd0bece17e8d16846bc37bca51b14bc42dd74da"
  end

  depends_on "python@3.11"

  resource "beautifulsoup4" do
    url "https://files.pythonhosted.org/packages/e8/b0/cd2b968000577ec5ce6c741a54d846dfa402372369b8b6861720aa9ecea7/beautifulsoup4-4.11.1.tar.gz"
    sha256 "ad9aa55b65ef2808eb405f46cf74df7fcb7044d5cbc26487f96eb2ef2e436693"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/cb/a4/7de7cd59e429bd0ee6521ba58a75adaec136d32f91a761b28a11d8088d44/certifi-2022.9.24.tar.gz"
    sha256 "0d9c601124e5a6ba9712dbc60d9c53c21e34f5f641fe83002317394311bdce14"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/a1/34/44964211e5410b051e4b8d2869c470ae8a68ae274953b1c7de6d98bbcf94/charset-normalizer-2.1.1.tar.gz"
    sha256 "5a3d016c7c547f69d6f81fb0db9449ce888b418b5b9952cc5e6e66843e9dd845"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/8b/e1/43beb3d38dba6cb420cefa297822eac205a277ab43e5ba5d5c46faf96438/idna-3.4.tar.gz"
    sha256 "814f528e8dead7d329833b91c5faa87d60bf71824cd12a7530b5526063d02cb4"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/a5/61/a867851fd5ab77277495a8709ddda0861b28163c4613b011bc00228cc724/requests-2.28.1.tar.gz"
    sha256 "7c5599b102feddaa661c826c56ab4fee28bfd17f5abca1ebbe3e7f19d7c97983"
  end

  resource "soupsieve" do
    url "https://files.pythonhosted.org/packages/f3/03/bac179d539362319b4779a00764e95f7542f4920084163db6b0fd4742d38/soupsieve-2.3.2.post1.tar.gz"
    sha256 "fc53893b3da2c33de295667a0e19f078c14bf86544af307354de5fcf12a3f30d"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/c2/51/32da03cf19d17d46cce5c731967bf58de9bd71db3a379932f53b094deda4/urllib3-1.26.13.tar.gz"
    sha256 "c083dd0dce68dbfbe1129d5271cb90f9447dea7d52097c6e0126120c521ddea8"
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
