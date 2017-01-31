class Shyaml < Formula
  include Language::Python::Virtualenv

  desc "Command-line YAML parser"
  homepage "https://github.com/0k/shyaml"
  url "https://files.pythonhosted.org/packages/67/70/1133a5817bc62ff4e7ceee59edb95d127092db9385cc7cda5fcac93c494a/shyaml-0.4.1.tar.gz"
  sha256 "a1535c25bf0058563e03ea8cbad8c4dc755ed231e6a9f3f584982994f19eae59"
  revision 4
  head "https://github.com/0k/shyaml.git"

  bottle do
    sha256 "a1bc1ac40a7026efefa3c9e45409031cf0ea99f96ad2dc8d83c9abdc40bc26f9" => :sierra
    sha256 "68c755c835380ab128447d9f2737942115398b7ebd419dc235bd1a0386e34bd0" => :el_capitan
    sha256 "6dc199af61dd4fdff54c3a62d310e93170fe49e374720fd4bfd72b7f979256e2" => :yosemite
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
