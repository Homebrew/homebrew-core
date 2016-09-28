class Shyaml < Formula
  include Language::Python::Virtualenv

  desc "Command-line YAML parser"
  homepage "https://github.com/0k/shyaml"
  url "https://files.pythonhosted.org/packages/67/70/1133a5817bc62ff4e7ceee59edb95d127092db9385cc7cda5fcac93c494a/shyaml-0.4.1.tar.gz"
  sha256 "a1535c25bf0058563e03ea8cbad8c4dc755ed231e6a9f3f584982994f19eae59"
  revision 1

  head "https://github.com/0k/shyaml.git"

  bottle do
    sha256 "de00b0f0d7459469b0e907c40d45d5a69b2da174bff5ba7d274aa71951747a9e" => :sierra
    sha256 "e90c127080c7b5d63ff8e1c0939502070ca5a69f02ac437432942c80b0bec97c" => :el_capitan
    sha256 "05f1e275abab2520255b419a85353ca07fcce797e4ba53de01d98a8f35acface" => :yosemite
    sha256 "3e06b5bf4687abd85598096d0977f43b49d78ba74ebad4aeb3fefc8eb85e23dd" => :mavericks
  end

  depends_on :python3

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
    assert_equal "val", pipe_output("shyaml get-value key", yaml, 0)
    assert_equal "1st", pipe_output("shyaml get-value arr.0", yaml, 0)
    assert_equal "2nd", pipe_output("shyaml get-value arr.-1", yaml, 0)
  end
end
