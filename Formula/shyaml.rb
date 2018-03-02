class Shyaml < Formula
  include Language::Python::Virtualenv

  desc "Command-line YAML parser"
  homepage "https://github.com/0k/shyaml"
  url "https://files.pythonhosted.org/packages/f7/ec/4143e8ba92d1d3654535f17bc4354f72d3a3e7d6984926d9a7ce1dec46ed/shyaml-0.5.0.tar.gz"
  sha256 "b3711011d37aae4e07b68b31e989aa3715548d5b0759898eda2ba437b9ae3c36"
  revision 2
  head "https://github.com/0k/shyaml.git"

  bottle do
    cellar :any
    sha256 "044879e607e3e85efbf673b5c3f16c6ad1ff804feeb06747beb7bbd7e26a05c9" => :high_sierra
    sha256 "428df655dd49f75ad8cb5bc607918567d2e665d69a0a615cc14c1889c7187424" => :sierra
    sha256 "0af1bd71bfda30abca1d8247afb45bcb7ae2a5fcc87a085258d209c44c8d27f5" => :el_capitan
  end

  depends_on "python"
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
