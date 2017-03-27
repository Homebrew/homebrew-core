class Shyaml < Formula
  include Language::Python::Virtualenv

  desc "Command-line YAML parser"
  homepage "https://github.com/0k/shyaml"
  url "https://files.pythonhosted.org/packages/f7/ec/4143e8ba92d1d3654535f17bc4354f72d3a3e7d6984926d9a7ce1dec46ed/shyaml-0.5.0.tar.gz"
  sha256 "b3711011d37aae4e07b68b31e989aa3715548d5b0759898eda2ba437b9ae3c36"
  head "https://github.com/0k/shyaml.git"

  bottle do
    sha256 "f0afeeca8b647539248c7aa60fb975259beb3e469b17d95370a97563f27d7053" => :sierra
    sha256 "68a1898adfb96714f7c82503de2f7ded35e343d96e2375565d276cb87a157eec" => :el_capitan
    sha256 "12e49f0710069f5ea9d9670525253c17d19435152da15954167af2161eb8019e" => :yosemite
  end

  depends_on :python3
  depends_on "libyaml"

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/4a/85/db5a2df477072b2902b0eb892feb37d88ac635d36245a72a6a69b23b383a/PyYAML-3.12.tar.gz"
    sha256 "592766c6303207a20efc445587778322d7f73b161bd994f227adaa341ba212ab"
  end

  def install
    virtualenv_create(libexec, "python3")
    virtualenv_install_with_resources
  end

  test do
    yaml = <<-EOS.undent
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
