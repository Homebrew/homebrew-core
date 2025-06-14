class YleDl < Formula
  include Language::Python::Virtualenv

  desc "Download Yle videos from the command-line"
  homepage "https://aajanki.github.io/yle-dl/index-en.html"
  url "https://files.pythonhosted.org/packages/47/dc/e544bc64b9e44c68bfbbd36c0d293bae2800ef8d4bb313b6feb4619ca031/yle_dl-20250614.tar.gz"
  sha256 "ed3d3f80c26fdb0854a8c6c14179171a2ba4117ebabea3e137f589c2bd8815d4"
  license "GPL-3.0-or-later"
  head "https://github.com/aajanki/yle-dl.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "16c452960dab831d367fb8f042551c839ee92332df47344bc65f725069f59dc3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c7eb56b68eceb4fa90324b6594784de64b75515aa35a8241c5d1f742eb59a705"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "651e39c6e62a996b1119b63909724780874869d658305ed7704447c2e35e6ac8"
    sha256 cellar: :any_skip_relocation, sonoma:        "3adbbcd49bd9b2df74ca125e3c7c6d4b1d1a4fdd69fb75a96bd8cf9b605810bf"
    sha256 cellar: :any_skip_relocation, ventura:       "203d59be94486a251f951d4d13d93dd531df15ed062524a9605a48d936c6deee"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "13568a4adba9f1a869ef7dc14e02397f14ba6caca41c53f1f17c3d65a0e16f58"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8ec160c0a6630ce544690835019eba89ba6760ad6c6d9675ae4a982130ba003d"
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
