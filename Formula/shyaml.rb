class Shyaml < Formula
  include Language::Python::Virtualenv

  desc "Command-line YAML parser"
  homepage "https://github.com/0k/shyaml"
  url "https://files.pythonhosted.org/packages/33/34/7ad4b645bdd5c6cd100748fc2429924b553439221aa9b9386f658e5a05f2/shyaml-0.5.2.tar.gz"
  sha256 "80650ebfe6fa2e16083451d515207472d60990c1c15fc0fd607c27077790ac23"
  revision 1
  head "https://github.com/0k/shyaml.git"

  bottle do
    cellar :any
    sha256 "9c781b5842ae5ac70560d07fa4bdd044777e66b25b594ad6e72bb1ea879fbbf7" => :high_sierra
    sha256 "c89bdfdd3d8b63503602ce9bccd7d2d4e418ad8f3a20661f17b643e14a9bc129" => :sierra
    sha256 "a217c5eeecdba87d025c7c089b69ee96a12704feb7f40ff02529a1b129991e75" => :el_capitan
  end

  depends_on "python"
  depends_on "libyaml"

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/bd/da/0a49c1a31c60634b93fd1376b3b7966c4f81f2da8263f389cad5b6bbd6e8/PyYAML-4.2b1.tar.gz"
    sha256 "ef3a0d5a5e950747f4a39ed7b204e036b37f9bddc7551c1a813b8727515a832e"
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
