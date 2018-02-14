class Shyaml < Formula
  include Language::Python::Virtualenv

  desc "Command-line YAML parser"
  homepage "https://github.com/0k/shyaml"
  url "https://files.pythonhosted.org/packages/f7/ec/4143e8ba92d1d3654535f17bc4354f72d3a3e7d6984926d9a7ce1dec46ed/shyaml-0.5.0.tar.gz"
  sha256 "b3711011d37aae4e07b68b31e989aa3715548d5b0759898eda2ba437b9ae3c36"
  revision 1
  head "https://github.com/0k/shyaml.git"

  bottle do
    cellar :any
    sha256 "70fcf4f5d11d52abca15111ffd92526f8be4c84cc508e0b0e6c933add01d92cd" => :high_sierra
    sha256 "d8405d1902db58c0f7c4112b82e9ca4bc3b45361e8418034285b7b023f68c0f6" => :sierra
    sha256 "bffb74c978bf45c8d6f6e117317066d9de9a211931e96c4c0c4d6e4d36f84bd9" => :el_capitan
  end

  depends_on "python3"
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
