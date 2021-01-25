class Shyaml < Formula
  include Language::Python::Virtualenv

  desc "Command-line YAML parser"
  homepage "https://github.com/0k/shyaml"
  url "https://files.pythonhosted.org/packages/b9/59/7e6873fa73a476de053041d26d112b65d7e1e480b88a93b4baa77197bd04/shyaml-0.6.2.tar.gz"
  sha256 "696e94f1c49d496efa58e09b49c099f5ebba7e24b5abe334f15e9759740b7fd0"
  license "BSD-2-Clause"
  head "https://github.com/0k/shyaml.git"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any
    sha256 "bdfdbc881e2ef1cc0ae52ad5cafae3715bdfaf76a1ac905a6e3aa3a7fc1736a2" => :big_sur
    sha256 "ff1ab13915b1148905c77a4bac3ff65db4bc496d3b2fcdf031f30678f781c9f1" => :arm64_big_sur
    sha256 "c95f616993a2fd70d3ed9fbb7556b582ef2aca26fbda97b36898bcfb9efbcee1" => :catalina
    sha256 "1f157591a67c0165af8492b3cb1b6049a7e151b0770aaed4c176c15fe3050f68" => :mojave
  end

  depends_on "libyaml"
  depends_on "python@3.9"

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/64/c2/b80047c7ac2478f9501676c988a5411ed5572f35d1beff9cae07d321512c/PyYAML-5.3.1.tar.gz"
    sha256 "b8eac752c5e14d3eca0e6dd9199cd627518cb5ec06add0de9d32baeee6fe645d"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    yaml = <<~EOS
      key: val
      arr:
        - 1st
        - 2nd
    EOS
    assert_equal "val", pipe_output("#{bin}/shyaml get-value key", yaml, 0)
    assert_equal "1st", pipe_output("#{bin}/shyaml get-value arr.0", yaml, 0)
    assert_equal "2nd", pipe_output("#{bin}/shyaml get-value arr.-1", yaml, 0)
  end
end
