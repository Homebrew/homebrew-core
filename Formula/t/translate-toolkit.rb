class TranslateToolkit < Formula
  include Language::Python::Virtualenv

  desc "Toolkit for localization engineers"
  homepage "https://toolkit.translatehouse.org/"
  url "https://files.pythonhosted.org/packages/f2/35/7264ad40d8ef95db2cdceadd808b479c5c289068bc2809db0ed265cc6f3c/translate_toolkit-3.15.2.tar.gz"
  sha256 "8b9cf1a6ffd3eb10757c77496c414bc6a6eb400bf88f10914257672431fe22ae"
  license "GPL-2.0-or-later"
  head "https://github.com/translate/translate.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "93e680e798291f70223c2cb28fc21a33495d11b3305c9ebde4951bb768ccf737"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e3e59f754e39baa1b08b7be9a40fa0c5ed6d3318399570b20f0dee66cb36adb4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "760dd04e4058d0ef441ce2694cb6a4bba2c5ebf4e46445009c53612ded9c4e4b"
    sha256 cellar: :any_skip_relocation, sonoma:        "d27e73ebfce34346dab06dd92ab55b9e2f14c450403f63e68fbb93985af67d3d"
    sha256 cellar: :any_skip_relocation, ventura:       "9a08b37359abd5147b52df44b390335f71820a2492906586ad668ad860e82ecf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "caeb90933eb921bb497ca9489cd429c59d41ee7acf53a371747a52e14b97fcd6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0bc8438508566659a1e37119762660ccd24b330794c26332dda4594695bf1160"
  end

  depends_on "python@3.13"

  uses_from_macos "libxml2", since: :ventura
  uses_from_macos "libxslt"

  resource "cwcwidth" do
    url "https://files.pythonhosted.org/packages/23/76/03fc9fb3441a13e9208bb6103ebb7200eba7647d040008b8303a1c03e152/cwcwidth-0.1.10.tar.gz"
    sha256 "7468760f72c1f4107be1b2b2854bc000401ea36a69daed36fb966a1e19a7a124"
  end

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/76/3d/14e82fc7c8fb1b7761f7e748fd47e2ec8276d137b6acfe5a4bb73853e08f/lxml-5.4.0.tar.gz"
    sha256 "d12832e1dbea4be280b22fd0ea7c9b87f0d8fc51ba06e92dc62d52f804f78ebd"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    test_file = testpath/"test.po"
    touch test_file
    assert_match "Processing file : #{test_file}", shell_output("#{bin}/pocount --no-color #{test_file}")

    assert_match version.to_s, shell_output("#{bin}/pretranslate --version")
    assert_match version.to_s, shell_output("#{bin}/podebug --version")
  end
end
