class Yapf < Formula
  include Language::Python::Virtualenv

  desc "Formatter for python code"
  homepage "https://github.com/google/yapf"
  url "https://files.pythonhosted.org/packages/23/97/b6f296d1e9cc1ec25c7604178b48532fa5901f721bcf1b8d8148b13e5588/yapf-0.43.0.tar.gz"
  sha256 "00d3aa24bfedff9420b2e0d5d9f5ab6d9d4268e72afbf59bb3fa542781d5218e"
  license "Apache-2.0"
  head "https://github.com/google/yapf.git", branch: "main"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, all: "55fb914de2771f27f304ac0b8fcdd5da19472f19ab59f9eacd8431e8dbaa4ec7"
  end

  depends_on "python@3.14"

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/61/33/9611380c2bdb1225fdef633e2a9610622310fed35ab11dac9620972ee088/platformdirs-4.5.0.tar.gz"
    sha256 "70ddccdd7c99fc5942e9fc25636a8b34d04c24b335100223152c2803e4063312"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    output = pipe_output(bin/"yapf", "x='homebrew'")
    assert_equal "x = 'homebrew'", output.strip
  end
end
