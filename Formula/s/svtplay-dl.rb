class SvtplayDl < Formula
  include Language::Python::Virtualenv

  desc "Download videos from https://www.svtplay.se/"
  homepage "https://svtplay-dl.se/"
  url "https://files.pythonhosted.org/packages/d0/4d/b0e5afb2ca53b7d3eb2bc3be5a86ebe14410b4b78465f1364ec32514be4e/svtplay_dl-4.197.tar.gz"
  sha256 "baa0210809bcf4dba10a1900781f05c8a95b698133fff518c29030d0ce87fdb7"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "89deda7cb7cda6db8189c584e97e70c56054bc9be1927bdbbcb8c2dec4ae5dba"
    sha256 cellar: :any, arm64_tahoe:       "fcd20deea62fcb3502acfbdecac3d61ceac0c5da97113c8b4ce22ab6273b0e91"
    sha256 cellar: :any, arm64_sequoia:     "b1ad95f8ec6e2cdcdec0ade4784224588be496729e5f217064a6e30a1172d0a6"
    sha256 cellar: :any, arm64_sonoma:      "c02312f3ee5e5350295aa00670ecfeaeac0734f633cc2a465fe9eb40f9aeac5f"
    sha256 cellar: :any, arm64_linux:       "7ef2de497b0781e92c04c64b5ffc63f79477b1ef3ef420b6090264b10df73232"
    sha256 cellar: :any, x86_64_linux:      "cfbc744b418fbcd506940d0d9ef937dea44e55fa9d52ec9451ea70c709bfba33"
  end

  depends_on "certifi"
  depends_on "cryptography"
  depends_on "libyaml"
  depends_on "python@3.14"

  pypi_packages exclude_packages: %w[certifi cryptography]

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/e5/3f/143b048436775b0f76ac3eec145c019e8173ccc2885c8f20319b996d5e83/charset_normalizer-3.5.1.tar.gz"
    sha256 "6117b84ea48435e5356dc737f5121485c30920ba43375fa7b434fd753df0eac3"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/5f/f7/abb373e5757eaec4b922b92f97ec8d6d7e057cf06778247604fbc4e7c3f3/idna-3.19.tar.gz"
    sha256 "5e0811a4383b21dc5838069f801c4fb62113b7447663d2530d2bd6e77b49bf15"
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
