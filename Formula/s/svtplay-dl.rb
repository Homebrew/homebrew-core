class SvtplayDl < Formula
  include Language::Python::Virtualenv

  desc "Download videos from https://www.svtplay.se/"
  homepage "https://svtplay-dl.se/"
  url "https://files.pythonhosted.org/packages/f2/ef/02ce377eee317bd5c69f77bfc93a8ba732654b5ebeb5ff3790b2daaf1448/svtplay_dl-4.193.tar.gz"
  sha256 "2e2222e3f8ffd79a8d44332d6254f66c9304adbb58122f2c0a7f3c17798da63d"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "ddbb7d06ee6053787fd924b4a817acea212c610b1eff3140a705661545fef511"
    sha256 cellar: :any, arm64_sequoia: "4b0185caebf9eb58ed3102bf778536073f520e0840fa7a01160065ce0ac09253"
    sha256 cellar: :any, arm64_sonoma:  "fd771ae7e52e3d0bac4a9d910b9c284233835b7742c6e84539a6c4836e719772"
    sha256 cellar: :any, sonoma:        "a2da1d651d72fb8ba4c79ebddea015aa60684a8e1a0add93e99a0b803d945f57"
    sha256 cellar: :any, arm64_linux:   "58a5526406db6ef066272177228ae58b584ef2e06895d53e5f072d1e049b4191"
    sha256 cellar: :any, x86_64_linux:  "a244f0c06b80ab358174b924d2974a35e1c769a305b339aafc18a958d4b18b10"
  end

  depends_on "certifi"
  depends_on "cryptography"
  depends_on "libyaml"
  depends_on "python@3.14"

  pypi_packages exclude_packages: %w[certifi cryptography]

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/bd/2a/23f34ec9d04624958e137efdc394888716353190e75f25dd22c7a2c7a8aa/charset_normalizer-3.4.9.tar.gz"
    sha256 "673611bbd43f0810bec0b0f028ddeaaa501190339cac411f347ac76917c3ae7b"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/cd/63/9496c57188a2ee585e0f1db071d75089a11e98aa86eb99d9d7618fc1edce/idna-3.18.tar.gz"
    sha256 "ffb385a7e039654cef1ab9ef32c6fafe283c0c0467bba1d9029738ce4a14a848"
  end

  resource "pysocks" do
    url "https://files.pythonhosted.org/packages/bd/11/293dd436aea955d45fc4e8a35b6ae7270f5b8e00b53cf6c024c83b657a11/PySocks-1.7.1.tar.gz"
    sha256 "3f8804571ebe159c380ac6de37643bb4685970655d3bba243530d6558b799aa0"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/ac/c3/e2a2b89f2d3e2179abd6d00ebd70bff6273f37fb3e0cc209f48b39d00cbf/requests-2.34.2.tar.gz"
    sha256 "f288924cae4e29463698d6d60bc6a4da69c89185ad1e0bcc4104f584e960b9ed"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/53/0c/06f8b233b8fd13b9e5ee11424ef85419ba0d8ba0b3138bf360be2ff56953/urllib3-2.7.0.tar.gz"
    sha256 "231e0ec3b63ceb14667c67be60f2f2c40a518cb38b03af60abc813da26505f4c"
  end

  def install
    virtualenv_install_with_resources
  end

  def caveats
    <<~EOS
      To use post-processing:
        `brew install ffmpeg`.
    EOS
  end

  test do
    url = "https://tv.aftonbladet.se/video/357803"
    match = "https://amd-ab.akamaized.net/ab/vod/2023/07/64b249d222f325d618162f76/720_3500_pkg.m3u8"
    assert_match match, shell_output("#{bin}/svtplay-dl -g #{url}")
  end
end
