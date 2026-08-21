class Yewtube < Formula
  include Language::Python::Virtualenv

  desc "Terminal based YouTube player and downloader"
  homepage "https://github.com/mps-youtube/yewtube"
  url "https://files.pythonhosted.org/packages/ab/0d/6c5fe6b0da51bbae6906317978ef38df505ec5920c843ab21a3acb9d945a/yewtube-2.13.1.tar.gz"
  sha256 "5e173433c5db16a7d2ff0ec0cb1201ebb50fa9997fcae272c14956610375257f"
  license "GPL-3.0-or-later"
  revision 4
  head "https://github.com/mps-youtube/yewtube.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "10f91bb176a8f094f3315893b516dda2dfb3a12de00e0d01e624ffdac101d762"
  end

  depends_on "certifi"
  depends_on "ffmpeg"
  depends_on "mplayer"
  depends_on "python@3.14"

  pypi_packages exclude_packages: "certifi"

  resource "anyio" do
    url "https://files.pythonhosted.org/packages/61/cc/a381afa6efea9f496eff839d4a6a1aed3bfafc7b3ab4b0d1b243a12573dd/anyio-4.14.2.tar.gz"
    sha256 "cfa139f3ed1a23ee8f88a145ddb5ac7605b8bbfd8592baacd7ce3d8bb4313c7f"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/bd/2a/23f34ec9d04624958e137efdc394888716353190e75f25dd22c7a2c7a8aa/charset_normalizer-3.4.9.tar.gz"
    sha256 "673611bbd43f0810bec0b0f028ddeaaa501190339cac411f347ac76917c3ae7b"
  end

  resource "h11" do
    url "https://files.pythonhosted.org/packages/01/ee/02a2c011bdab74c6fb3c75474d40b3052059d95df7e73351460c8588d963/h11-0.16.0.tar.gz"
    sha256 "4e35b956cf45792e4caa5885e69fba00bdbc6ffafbfa020300e549b208ee5ff1"
  end

  resource "httpcore" do
    url "https://files.pythonhosted.org/packages/06/94/82699a10bca87a5556c9c59b5963f2d039dbd239f25bc2a63907a05a14cb/httpcore-1.0.9.tar.gz"
    sha256 "6e34463af53fd2ab5d807f399a9b45ea31c3dfa2276f15a2c3f00afff6e176e8"
  end

  resource "httpcore2" do
    url "https://files.pythonhosted.org/packages/39/a8/20ed1ed79cbc2ecdf5301c0968ab7c85547212e2a7bd126ddd2d986e206e/httpcore2-2.9.1.tar.gz"
    sha256 "4d8acbf8b306f48c9d6046591fd5ba4037d1b1b1000d140fc2c3eab1e9a0c0e2"
  end

  resource "httpx" do
    url "https://files.pythonhosted.org/packages/78/82/08f8c936781f67d9e6b9eeb8a0c8b4e406136ea4c3d1f89a5db71d42e0e6/httpx-0.27.2.tar.gz"
    sha256 "f7c2be1d2f3c3c3160d441802406b206c2b76f5947b11115e6df10c6c65e66c2"
  end

  resource "httpx2" do
    url "https://files.pythonhosted.org/packages/21/14/38128fbafd7e0ed41d874df6c9a653d47c2d111cfe59e2b4ac95161b4abd/httpx2-2.9.1.tar.gz"
    sha256 "1932a768737e3666291582833da748cc4e563c337cf96706fccc04fa6e58764a"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/cd/63/9496c57188a2ee585e0f1db071d75089a11e98aa86eb99d9d7618fc1edce/idna-3.18.tar.gz"
    sha256 "ffb385a7e039654cef1ab9ef32c6fafe283c0c0467bba1d9029738ce4a14a848"
  end

  resource "pylast" do
    url "https://files.pythonhosted.org/packages/5e/1d/aaf99f82be962381ac07331106c72ff201ad98da9f18e74c0ee5f74e5a41/pylast-7.1.0.tar.gz"
    sha256 "0c1fc381d649f256842c665ede52591d3b32789e281cd9b5601c01d2dc3a2d88"
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

  resource "truststore" do
    url "https://files.pythonhosted.org/packages/53/a3/1585216310e344e8102c22482f6060c7a6ea0322b63e026372e6dcefcfd6/truststore-0.10.4.tar.gz"
    sha256 "9d91bd436463ad5e4ee4aba766628dd6cd7010cf3e2461756b3303710eebc301"
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
    url "https://files.pythonhosted.org/packages/47/c5/9972af4b472b0d55badf841ebafd2f98944cb0ae0f46e11d01f363ea5b91/yt_dlp-2026.7.4.tar.gz"
    sha256 "b094813404f87a9dd2186f00815231df32e5fd8a5403be0f807b3bb2d21a4432"
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
