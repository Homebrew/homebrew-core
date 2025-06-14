class YleDl < Formula
  include Language::Python::Virtualenv

  desc "Download Yle videos from the command-line"
  homepage "https://aajanki.github.io/yle-dl/index-en.html"
  url "https://files.pythonhosted.org/packages/47/dc/e544bc64b9e44c68bfbbd36c0d293bae2800ef8d4bb313b6feb4619ca031/yle_dl-20250614.tar.gz"
  sha256 "ed3d3f80c26fdb0854a8c6c14179171a2ba4117ebabea3e137f589c2bd8815d4"
  license "GPL-3.0-or-later"
  head "https://github.com/aajanki/yle-dl.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b569b1ba0db4d281aad042e2c2b39ab37da5ed188d6612e4d21951656c1d04bf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ee5e49166aa09568e8959e46bf893b1bfcf4e91fa14e66798b78de3de449cd98"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "997faeccc62e26564c7f41d28ee06811d2ae2860ff4fc2a85fc28df5a4e2edd7"
    sha256 cellar: :any_skip_relocation, sonoma:        "10692557403ebae84f5d40bef79f14942e9517e482d8e41f323d39422a7e94fb"
    sha256 cellar: :any_skip_relocation, ventura:       "763ff8308ffb6a5b92727cf9c33863f069a9835dbc0f6cc3e5d5754ec727a414"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ec2681df693b734b0e791dbac02dcee4af79d819d990245ff7c1d2756abe14b9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3191d770ce559b3599fa00435e532d6cfcfae0b4b008c44376aa2180a49ab1d7"
  end

  depends_on "certifi"
  depends_on "ffmpeg"
  depends_on "python@3.13"
  depends_on "rtmpdump"

  uses_from_macos "libxml2", since: :ventura
  uses_from_macos "libxslt"

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/e4/33/89c2ced2b67d1c2a61c19c6751aa8902d46ce3dacb23600a283619f5a12d/charset_normalizer-3.4.2.tar.gz"
    sha256 "5baececa9ecba31eff645232d59845c07aa030f0c81ee70184a90d35099a0e63"
  end

  resource "configargparse" do
    url "https://files.pythonhosted.org/packages/85/4d/6c9ef746dfcc2a32e26f3860bb4a011c008c392b83eabdfb598d1a8bbe5d/configargparse-1.7.1.tar.gz"
    sha256 "79c2ddae836a1e5914b71d58e4b9adbd9f7779d4e6351a637b7d2d9b6c46d3d9"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/f1/70/7703c29685631f5a7590aa73f1f1d3fa9a380e654b86af429e0934a32f7d/idna-3.10.tar.gz"
    sha256 "12f65c9b470abda6dc35cf8e63cc574b1c52b11df2c86030af0ac09b01b13ea9"
  end

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/76/3d/14e82fc7c8fb1b7761f7e748fd47e2ec8276d137b6acfe5a4bb73853e08f/lxml-5.4.0.tar.gz"
    sha256 "d12832e1dbea4be280b22fd0ea7c9b87f0d8fc51ba06e92dc62d52f804f78ebd"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/e1/0a/929373653770d8a0d7ea76c37de6e41f11eb07559b103b1c02cafb3f7cf8/requests-2.32.4.tar.gz"
    sha256 "27d0316682c8a29834d3264820024b62a36942083d52caf2f14c0591336d3422"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/8a/78/16493d9c386d8e60e442a35feac5e00f0913c0f4b7c217c11e8ec2ff53e0/urllib3-2.4.0.tar.gz"
    sha256 "414bc6535b787febd7567804cc015fee39daab8ad86268f1310a9250697de466"
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
