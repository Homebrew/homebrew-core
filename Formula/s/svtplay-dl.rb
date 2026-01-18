class SvtplayDl < Formula
  include Language::Python::Virtualenv

  desc "Download videos from https://www.svtplay.se/"
  homepage "https://svtplay-dl.se/"
  url "https://files.pythonhosted.org/packages/34/37/e1d6da9ba4fe77111df66873ad74e4d46a560cd0fc57891cde6908d1e6ea/svtplay_dl-4.173.tar.gz"
  sha256 "d50405a8eaaae44482a74cdcacfead72d6926d39e9239404ff6206f84275144b"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "57932040fc0611981c893a8d303d20e7e17c03d2720967246a3f014ead3b1a4f"
    sha256 cellar: :any,                 arm64_sequoia: "02c899181bdf2761714a51e01a2cadef3066c6c1fb1b94c3fdf5d5fc7b366076"
    sha256 cellar: :any,                 arm64_sonoma:  "cafcbafc6429fa5f0c17eb6cec1fd0c69b99d276d2501fc030d24f021e05bf4e"
    sha256 cellar: :any,                 sonoma:        "c2f3a06c598f0af40524a86b338e03e89e75dd2961fe7769d20e045e0f71e9a8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d417f49366c5fedb6415db9aea4cad6fbf5bc3ccc36f2c0b903d06d06474d159"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1750a884743e616f56e2834dc6675a4ec0053492786357ceee36f10ab2d3d63a"
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
    url "https://files.pythonhosted.org/packages/c7/24/5f1b3bdffd70275f6661c76461e25f024d5a38a46f04aaca912426a2b1d3/urllib3-2.6.3.tar.gz"
    sha256 "1b62b6884944a57dbe321509ab94fd4d3b307075e0c2eae991ac71ee15ad38ed"
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
