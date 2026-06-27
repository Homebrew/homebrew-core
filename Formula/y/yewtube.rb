class Yewtube < Formula
  include Language::Python::Virtualenv

  desc "Terminal based YouTube player and downloader"
  homepage "https://github.com/mps-youtube/yewtube"
  url "https://files.pythonhosted.org/packages/ab/0d/6c5fe6b0da51bbae6906317978ef38df505ec5920c843ab21a3acb9d945a/yewtube-2.13.1.tar.gz"
  sha256 "5e173433c5db16a7d2ff0ec0cb1201ebb50fa9997fcae272c14956610375257f"
  license "GPL-3.0-or-later"
  revision 3
  head "https://github.com/mps-youtube/yewtube.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "0171eda10dacfdb7ed779e9c75028ddcc39cd4e089b4eb6c65c1bae61c1e5b01"
  end

  depends_on "certifi"
  depends_on "ffmpeg"
  depends_on "mplayer"
  depends_on "python@3.14"

  pypi_packages exclude_packages: "certifi"

  resource "anyio" do
    url "https://files.pythonhosted.org/packages/1c/b5/001890774a9552aff22502b8da382593109ce0c95314abaebbb116567545/anyio-4.14.0.tar.gz"
    sha256 "b47c1f9ccf73e67021df785332508f99379c68fa7d0684e8e3492cb1d4b23f89"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/e7/a1/67fe25fac3c7642725500a3f6cfe5821ad557c3abb11c9d20d12c7008d3e/charset_normalizer-3.4.7.tar.gz"
    sha256 "ae89db9e5f98a11a4bf50407d4363e7b09b31e55bc117b4f7d80aab97ba009e5"
  end

  resource "h11" do
    url "https://files.pythonhosted.org/packages/01/ee/02a2c011bdab74c6fb3c75474d40b3052059d95df7e73351460c8588d963/h11-0.16.0.tar.gz"
    sha256 "4e35b956cf45792e4caa5885e69fba00bdbc6ffafbfa020300e549b208ee5ff1"
  end

  resource "httpcore" do
    url "https://files.pythonhosted.org/packages/06/94/82699a10bca87a5556c9c59b5963f2d039dbd239f25bc2a63907a05a14cb/httpcore-1.0.9.tar.gz"
    sha256 "6e34463af53fd2ab5d807f399a9b45ea31c3dfa2276f15a2c3f00afff6e176e8"
  end

  resource "httpx" do
    url "https://files.pythonhosted.org/packages/78/82/08f8c936781f67d9e6b9eeb8a0c8b4e406136ea4c3d1f89a5db71d42e0e6/httpx-0.27.2.tar.gz"
    sha256 "f7c2be1d2f3c3c3160d441802406b206c2b76f5947b11115e6df10c6c65e66c2"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/cd/63/9496c57188a2ee585e0f1db071d75089a11e98aa86eb99d9d7618fc1edce/idna-3.18.tar.gz"
    sha256 "ffb385a7e039654cef1ab9ef32c6fafe283c0c0467bba1d9029738ce4a14a848"
  end

  resource "pylast" do
    url "https://files.pythonhosted.org/packages/dc/56/1729aa02df4bf959f31f6bd024775f8be0aaa08fd18a1d2bbdaab3c38e9e/pylast-7.0.2.tar.gz"
    sha256 "825e2b5d9144c5491d9c353511169a1595813e6a1ad203faf7525cd2d1d1828e"
  end

  resource "pyperclip" do
    url "https://files.pythonhosted.org/packages/e8/52/d87eba7cb129b81563019d1679026e7a112ef76855d6159d24754dbd2a51/pyperclip-1.11.0.tar.gz"
    sha256 "244035963e4428530d9e3a6101a1ef97209c6825edab1567beac148ccc1db1b6"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/ac/c3/e2a2b89f2d3e2179abd6d00ebd70bff6273f37fb3e0cc209f48b39d00cbf/requests-2.34.2.tar.gz"
    sha256 "f288924cae4e29463698d6d60bc6a4da69c89185ad1e0bcc4104f584e960b9ed"
  end

  resource "sniffio" do
    url "https://files.pythonhosted.org/packages/a2/87/a6771e1546d97e7e041b6ae58d80074f81b7d5121207425c964ddf5cfdbd/sniffio-1.3.1.tar.gz"
    sha256 "f4324edc670a0f49750a81b895f35c3adb843cca46f0530f79fc1babb23789dc"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/53/0c/06f8b233b8fd13b9e5ee11424ef85419ba0d8ba0b3138bf360be2ff56953/urllib3-2.7.0.tar.gz"
    sha256 "231e0ec3b63ceb14667c67be60f2f2c40a518cb38b03af60abc813da26505f4c"
  end

  resource "yewtube-search-python" do
    url "https://files.pythonhosted.org/packages/3a/7a/8ed3133214207ff95f503e9c20a69b469a28d47f7a9bdf274b044e0f5b95/yewtube_search_python-1.6.7.tar.gz"
    sha256 "87d0d728f8ed5a929570c061b5e7335767d04497e2141371da94744c3327506e"
  end

  resource "yt-dlp" do
    url "https://files.pythonhosted.org/packages/88/a4/1b0979d28f87774bb67fbbc66bce44f9dd1aa0e547a99e22985fac945c33/yt_dlp-2026.6.9.tar.gz"
    sha256 "d50fcb95f48d61bedde33e408c1881d4c279e51c31354a599ce09e96ba0f4b86"
  end

  def install
    virtualenv_install_with_resources

    # Build an `:all` bottle by adding a file only used in linux to macos
    (libexec/"share/applications").install "yewtube.desktop" if OS.mac?
  end

  test do
    assert_match "checkupdate set to False", shell_output("#{bin}/yt set checkupdate false, exit")
  end
end
