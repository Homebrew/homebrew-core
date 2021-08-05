class Yamllint < Formula
  include Language::Python::Virtualenv

  desc "Linter for YAML files"
  homepage "https://github.com/adrienverge/yamllint"
  url "https://files.pythonhosted.org/packages/74/2f/05aff60fa063c49c28bd24f4f848d9a81583c65082de154fcd2a467548e6/yamllint-1.26.2.tar.gz"
  sha256 "0b08a96750248fdf21f1e8193cb7787554ef75ed57b27f621cd6b3bf09af11a1"
  license "GPL-3.0-or-later"
  head "https://github.com/adrienverge/yamllint.git"

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "ec081da4389f0be3a24fe64d789291aa91d3e085661c0e728c512dec0dc168e4"
    sha256 cellar: :any,                 big_sur:       "e10a5e22a725acbb86a6b76a98b507a5c308333c7b31e366756ab8ca7e2c2305"
    sha256 cellar: :any,                 catalina:      "1d7a3eb846a89b904f0c9c9a973577996c63556ac919e3c96bd47c0477fe6322"
    sha256 cellar: :any,                 mojave:        "4f16379fcb5e3142113a3c122e835b131b04e1d99348de9cf1bd7c5608006276"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "57cba42a91db5d04438f9823810635751f5c65ce8a5c15b874de3113a2bd6b91"
  end

  depends_on "libyaml"
  depends_on "python@3.9"

  resource "pathspec" do
    url "https://files.pythonhosted.org/packages/f6/33/436c5cb94e9f8902e59d1d544eb298b83c84b9ec37b5b769c5a0ad6edb19/pathspec-0.9.0.tar.gz"
    sha256 "e564499435a2673d586f6b2130bb5b95f04a3ba06f81b8f895b651a3c76aabb1"
  end

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/a0/a4/d63f2d7597e1a4b55aa3b4d6c5b029991d3b824b5bd331af8d4ab1ed687d/PyYAML-5.4.1.tar.gz"
    sha256 "607774cbba28732bfa802b54baa7484215f530991055bb562efbed5b2f20a45e"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"bad.yaml").write <<~EOS
      ---
      foo: bar: gee
    EOS
    output = shell_output("#{bin}/yamllint -f parsable -s bad.yaml", 1)
    assert_match "syntax error: mapping values are not allowed here", output

    (testpath/"good.yaml").write <<~EOS
      ---
      foo: bar
    EOS
    assert_equal "", shell_output("#{bin}/yamllint -f parsable -s good.yaml")
  end
end
