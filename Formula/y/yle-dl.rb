class YleDl < Formula
  include Language::Python::Virtualenv

  desc "Download Yle videos from the command-line"
  homepage "https://aajanki.github.io/yle-dl/index-en.html"
  url "https://files.pythonhosted.org/packages/1f/82/cf37a73bb0c223e80484d337aed3fa0d6b855512b1b36dde9b8eb062907a/yle_dl-20240806.tar.gz"
  sha256 "7697c7e232858ecd74bd5850314ed2ebeb85bca855056f111920cb1192c64cab"
  license "GPL-3.0-or-later"
  head "https://github.com/aajanki/yle-dl.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bad19e5d0bf45516e2998bcfb3859cdb1c65aaba9406b22df3ba0a91778a16b1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c3e450a91ff7d87d600926df7e0ab3f4cd42a644d52e96da818436c58638e158"
    sha256 cellar: :any,                 arm64_monterey: "1de9a5ccf63b004b5fa64db2142feed97ee20518e63ba20a2815573e8846f70d"
    sha256 cellar: :any_skip_relocation, sonoma:         "69d77238a756584fd72fa4b1737c8d74ed61a20fe3f87ab8b3a594b5377344fd"
    sha256 cellar: :any_skip_relocation, ventura:        "c72b69b7ecf3e0a0e1e63bf885628c86c54b1af87abe1e4c19ec83662111fa01"
    sha256 cellar: :any,                 monterey:       "a1f39a0105371462475fd626e84333d31a3ea15923572761c76d9b7d75bd7a22"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d9352dac3bbad3596b9796cb98f1ca988bb1557038f833362a2a13b03cd22ad1"
  end

  depends_on "certifi"
  depends_on "ffmpeg"
  depends_on "python@3.12"
  depends_on "rtmpdump"

  uses_from_macos "libxml2", since: :ventura
  uses_from_macos "libxslt"

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/63/09/c1bc53dab74b1816a00d8d030de5bf98f724c52c1635e07681d312f20be8/charset-normalizer-3.3.2.tar.gz"
    sha256 "f30c3cb33b24454a82faecaf01b19c18562b1e89558fb6c56de4d9118a032fd5"
  end

  resource "configargparse" do
    url "https://files.pythonhosted.org/packages/70/8a/73f1008adfad01cb923255b924b1528727b8270e67cb4ef41eabdc7d783e/ConfigArgParse-1.7.tar.gz"
    sha256 "e7067471884de5478c58a511e529f0f9bd1c66bfef1dea90935438d6c23306d1"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/21/ed/f86a79a07470cb07819390452f178b3bef1d375f2ec021ecfc709fc7cf07/idna-3.7.tar.gz"
    sha256 "028ff3aadf0609c1fd278d8ea3089299412a7a8b9bd005dd08b9f8285bcb5cfc"
  end

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/63/f7/ffbb6d2eb67b80a45b8a0834baa5557a14a5ffce0979439e7cd7f0c4055b/lxml-5.2.2.tar.gz"
    sha256 "bb2dc4898180bea79863d5487e5f9c7c34297414bad54bcd0f0852aee9cfdb87"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/63/70/2bf7780ad2d390a8d301ad0b550f1581eadbd9a20f896afe06353c2a2913/requests-2.32.3.tar.gz"
    sha256 "55365417734eb18255590a9ff9eb97e9e1da868d4ccd6402399eaf68af20a760"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/43/6d/fa469ae21497ddc8bc93e5877702dca7cb8f911e337aca7452b5724f1bb6/urllib3-2.2.2.tar.gz"
    sha256 "dd505485549a7a552833da5e6063639d0d177c04f23bc3864e41e5dc5f612168"
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
