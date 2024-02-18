class YleDl < Formula
  desc "Download Yle videos from the command-line"
  homepage "https://aajanki.github.io/yle-dl/index-en.html"
  url "https://files.pythonhosted.org/packages/5c/ba/ae9008b208cfc78f8de4b32ea98d4107d6bf940e5062f8985f70dd18b086/yle_dl-20240130.tar.gz"
  sha256 "fe871fe3d63c232183f52d234f3e54afa2cffa8aa697a94197d2d3947b19e37d"
  license "GPL-3.0-or-later"
  head "https://github.com/aajanki/yle-dl.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5e658ddd73cb19f6b64001113f25b44cad9b0a3202e4f80960057ac1989293e0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "10f5886900a8de7f2b2687b9f4667e59cee0b5c97e7f6bc1d80671083138ffd0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "00d490998e01c565ba104033e5078d8f2662121b059be10b34e2e1250d1733c7"
    sha256 cellar: :any_skip_relocation, sonoma:         "3ace467ab97f097780a62c727851de7ab553dc202d864466ec8fb0e8d2e5f764"
    sha256 cellar: :any_skip_relocation, ventura:        "f7943694c6e3e351f5e1b396332ce49c29173598cc255c4eb3efd480f03765a2"
    sha256 cellar: :any_skip_relocation, monterey:       "e6fee0f7f0b821b876191a09097416922b97d94664f0ad472ccac00716d60900"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7feb6a3e7c0a7f32a91bb7ecd8ad8337b39bd9824dde2962d35f90ebda124057"
  end

  depends_on "python-flit-core" => :build
  depends_on "cffi"
  depends_on "ffmpeg"
  depends_on "pycparser"
  depends_on "python-configargparse"
  depends_on "python-lxml"
  depends_on "python-requests"
  depends_on "python@3.12"
  depends_on "rtmpdump"

  def python3
    "python3.12"
  end

  def install
    system python3, "-m", "pip", "install", *std_pip_args, "."
  end

  test do
    output = shell_output("#{bin}/yle-dl --showtitle https://areena.yle.fi/1-1570236")
    assert_match "Traileri:", output
    assert_match "2012-05-30T10:51", output
  end
end
