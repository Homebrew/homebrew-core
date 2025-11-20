class SvtplayDl < Formula
  include Language::Python::Virtualenv

  desc "Download videos from https://www.svtplay.se/"
  homepage "https://svtplay-dl.se/"
  url "https://files.pythonhosted.org/packages/6b/52/879fac8cd8686b016eaf2771a0ab93795f0f13eafafd8c853bdb87db9f57/svtplay_dl-4.163.tar.gz"
  sha256 "5db04ca95629c8280f6698a259053c8ba528a08175f638c04e3ed8bb447b6f56"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "c8eeaad78576772cbdae0015864f004ea8bf85f4d68ea17ad19d0fc76ed8efb1"
    sha256 cellar: :any,                 arm64_sequoia: "1c0c8ee8b0aa9dd666565d084215c9e5a58ac4a39fdc51f34cc0581dd0429b59"
    sha256 cellar: :any,                 arm64_sonoma:  "a5d607495ec83d9c282793b51ab925a4c9b8444300352be0cd75f2a5a13901d0"
    sha256 cellar: :any,                 sonoma:        "e9887f3a9c93469b0e1bf5baf4efe72e2a40d56be6fae0c529f6c528fc9c7dd4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "86eba78ab1a551d4449506cfcc557a5d0c64f7f64b0eb826ea75c4a4830ec2d6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1218aa050e8c24617be5c257755986ec728f7272f00de25cb94314e8a5883cb2"
  end

  depends_on "certifi"
  depends_on "cryptography"
  depends_on "libyaml"
  depends_on "python@3.14"

  pypi_packages exclude_packages: %w[certifi cryptography]

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/13/69/33ddede1939fdd074bce5434295f38fae7136463422fe4fd3e0e89b98062/charset_normalizer-3.4.4.tar.gz"
    sha256 "94537985111c35f28720e43603b8e7b43a6ecfb2ce1d3058bbe955b73404e21a"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/6f/6d/0703ccc57f3a7233505399edb88de3cbd678da106337b9fcde432b65ed60/idna-3.11.tar.gz"
    sha256 "795dafcc9c04ed0c1fb032c2aa73654d8e8c5023a7df64a53f39190ada629902"
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
    url "https://files.pythonhosted.org/packages/c9/74/b3ff8e6c8446842c3f5c837e9c3dfcfe2018ea6ecef224c710c85ef728f4/requests-2.32.5.tar.gz"
    sha256 "dbba0bac56e100853db0ea71b82b4dfd5fe2bf6d3754a8893c3af500cec7d7cf"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/15/22/9ee70a2574a4f4599c47dd506532914ce044817c7752a79b6a51286319bc/urllib3-2.5.0.tar.gz"
    sha256 "3fc47733c7e419d4bc3f6b3dc2b4f890bb743906a30d56ba4a5bfa4bbff92760"
  end

  def install
    virtualenv_install_with_resources
  end

  def caveats
    <<~EOS
      To use post-processing options:
        `brew install ffmpeg` or `brew install libav`.
    EOS
  end

  test do
    url = "https://tv.aftonbladet.se/video/357803"
    match = "https://amd-ab.akamaized.net/ab/vod/2023/07/64b249d222f325d618162f76/720_3500_pkg.m3u8"
    assert_match match, shell_output("#{bin}/svtplay-dl -g #{url}")
  end
end
