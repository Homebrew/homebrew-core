class Yapf < Formula
  include Language::Python::Virtualenv

  desc "Formatter for python code"
  homepage "https://github.com/google/yapf"
  url "https://files.pythonhosted.org/packages/83/6e/72395cbbd59eedc48913f8694d445acbdba699c50312001b702c5ff46001/yapf-0.33.0.tar.gz"
  sha256 "da62bdfea3df3673553351e6246abed26d9fe6780e548a5af9e70f6d2b4f5b9a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "231981acae588f6bfe8fbb434609c00a985d8e1d57fefa12debd9965fe7f82e9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3402f5d670fa80ecbc1a6afca035b796bce209411b56aa3ca3dcc99a52311e31"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "be9fd597d3052e65bc35ff92f5abac0e63f0854361364b7cbf318f8e786a160e"
    sha256 cellar: :any_skip_relocation, ventura:        "87164b623df7a3e536e404b5183b68b499655387ee65872a46a8b26f810de206"
    sha256 cellar: :any_skip_relocation, monterey:       "4dc3753f25ecd807fe3226141d86e7f1dbe67b8045b8c458a517413aed24a4db"
    sha256 cellar: :any_skip_relocation, big_sur:        "0a9d42d1e2d7f88c6ca9fe9489d18013efa70186dad5b365ad50f84f8f924882"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2741a25f9a4f7d99c66aaad53f5d71a7a875d2bd05dacee831a25d43194ec650"
  end

  depends_on "python@3.11"

  resource "tomli" do
    url "https://files.pythonhosted.org/packages/c0/3f/d7af728f075fb08564c5949a9c95e44352e23dee646869fa104a3b2060a3/tomli-2.0.1.tar.gz"
    sha256 "de526c12914f0c550d15924c62d72abc48d6fe7364aa87328337a31007fe8a4f"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    output = pipe_output("#{bin}/yapf", "x='homebrew'")
    assert_equal "x = 'homebrew'", output.strip
  end
end
