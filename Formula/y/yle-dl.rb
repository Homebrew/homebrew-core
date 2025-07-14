class YleDl < Formula
  include Language::Python::Virtualenv

  desc "Download Yle videos from the command-line"
  homepage "https://aajanki.github.io/yle-dl/index-en.html"
  url "https://files.pythonhosted.org/packages/47/dc/e544bc64b9e44c68bfbbd36c0d293bae2800ef8d4bb313b6feb4619ca031/yle_dl-20250614.tar.gz"
  sha256 "ed3d3f80c26fdb0854a8c6c14179171a2ba4117ebabea3e137f589c2bd8815d4"
  license "GPL-3.0-or-later"
  revision 1
  head "https://github.com/aajanki/yle-dl.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b538a4dcb34db9704c829a14ff23eabad8c94be0e97fce384fa28afb9cf0c971"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0671419447f32e2f5d0d8cdcdcec31cd145b6deb26c55059e000ff8609d9bdc4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "408ef75bdf3c659db26cf9c5bde32bae8cf757acf6a46cffb146b7c685bf133c"
    sha256 cellar: :any_skip_relocation, sonoma:        "e1d612443f0c7431837290ab124faddf2a9009fe6fd6e87723848ad845abb34b"
    sha256 cellar: :any_skip_relocation, ventura:       "0ea187e48a7ce17a29b5ba97dc56146a805ffaafef7bf01ec61630949be21727"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cb2d794199c4c8d5664633641643c317153e4e8ed0de225feba52f39edbbaa22"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "29d8ecb5f2db3f2cafe2829132d2af5a9948f3a30038d3a16f0ad23ae064b10f"
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
    url "https://files.pythonhosted.org/packages/15/22/9ee70a2574a4f4599c47dd506532914ce044817c7752a79b6a51286319bc/urllib3-2.5.0.tar.gz"
    sha256 "3fc47733c7e419d4bc3f6b3dc2b4f890bb743906a30d56ba4a5bfa4bbff92760"
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
