class YleDl < Formula
  include Language::Python::Virtualenv

  desc "Download Yle videos from the command-line"
  homepage "https://aajanki.github.io/yle-dl/index-en.html"
  url "https://files.pythonhosted.org/packages/a1/92/f2c10d7390899c9f26e08102143d9c0a8d375a7d7a7314e17913ddfa162e/yle_dl-20250730.tar.gz"
  sha256 "2122741f515d5829eff28b2f6b96c251f4f7434412ea6c3ca60e526e60563c89"
  license "GPL-3.0-or-later"
  revision 3
  head "https://github.com/aajanki/yle-dl.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0d67b5633ba8b0e56a467d11488447b79550f54c2465111f52b40aa6e4a98573"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "776889ed5e08f7ff1163ab55b42f2266ec8e407631003a0af2fc15e222dc1ffe"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "53dc8dcb927ac65d64368da9b475b24baced3f9e678012f2174553a987c0ee16"
    sha256 cellar: :any_skip_relocation, sonoma:        "b502856a8098e86d4acac6143c0d1ec4d4ce24c511b6422c4705211549d5f859"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d9f47466eac8bb391ef77e43bfb88eb67d68f5fc576bc1cf9b7745682e0a6d2e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "471c142f296490781521ce551a8c1bc96973a1fe02ed3180da9f8864e9099abd"
  end

  depends_on "certifi"
  depends_on "ffmpeg"
  depends_on "python@3.14"
  depends_on "rtmpdump"

  uses_from_macos "libxml2", since: :ventura
  uses_from_macos "libxslt"

  pypi_packages exclude_packages: "certifi"

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/13/69/33ddede1939fdd074bce5434295f38fae7136463422fe4fd3e0e89b98062/charset_normalizer-3.4.4.tar.gz"
    sha256 "94537985111c35f28720e43603b8e7b43a6ecfb2ce1d3058bbe955b73404e21a"
  end

  resource "configargparse" do
    url "https://files.pythonhosted.org/packages/85/4d/6c9ef746dfcc2a32e26f3860bb4a011c008c392b83eabdfb598d1a8bbe5d/configargparse-1.7.1.tar.gz"
    sha256 "79c2ddae836a1e5914b71d58e4b9adbd9f7779d4e6351a637b7d2d9b6c46d3d9"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/6f/6d/0703ccc57f3a7233505399edb88de3cbd678da106337b9fcde432b65ed60/idna-3.11.tar.gz"
    sha256 "795dafcc9c04ed0c1fb032c2aa73654d8e8c5023a7df64a53f39190ada629902"
  end

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/aa/88/262177de60548e5a2bfc46ad28232c9e9cbde697bd94132aeb80364675cb/lxml-6.0.2.tar.gz"
    sha256 "cd79f3367bd74b317dda655dc8fcfa304d9eb6e4fb06b7168c5cf27f96e0cd62"
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

  test do
    output = shell_output("#{bin}/yle-dl --showtitle https://areena.yle.fi/1-1570236")
    assert_match "Traileri:", output
    assert_match "2012-05-30T10:51", output
  end
end
