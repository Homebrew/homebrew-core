class Yamale < Formula
  include Language::Python::Virtualenv

  desc "Schema and validator for YAML"
  homepage "https://github.com/23andMe/Yamale"
  url "https://files.pythonhosted.org/packages/c9/7b/3c0e9ecf5f5ad25700cc9993efb607d748658b2cd2492bda0adf8b6087dc/yamale-4.0.2.tar.gz"
  sha256 "4168f8b3650cece80552fd32edd894ab9081dd9ef959cadd9f1f23795629e4f2"
  license "MIT"
  head "https://github.com/23andMe/Yamale.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "20239cbb6c91b60b6498719d9975890b2ae04024ce27f04de6606054e5cea52f"
    sha256 cellar: :any,                 arm64_big_sur:  "f6f73561bd55c42a6d269f1d1088191f2a2c3d0c59bf47458ebcfdcdaa813a74"
    sha256 cellar: :any,                 monterey:       "2cc0f0d1e82b8f0196e1d47bdf72f186a7fe63fa29cc8f20bf0079c1b5c888fe"
    sha256 cellar: :any,                 big_sur:        "57edaa9dbb31711ed0152049e0d952bf87d9bb8d6bb33f93065f9592913b3f13"
    sha256 cellar: :any,                 catalina:       "9ff707f6faef7e4806770bc94314f5c09ead2120ea2c1140740018ddd32b5f1f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b2e31112970b1897b3c58bce4533460d45f36cbdbaa7352d652ce3864ffa7dfe"
  end

  depends_on "libyaml"
  depends_on "python@3.10"

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/a0/a4/d63f2d7597e1a4b55aa3b4d6c5b029991d3b824b5bd331af8d4ab1ed687d/PyYAML-5.4.1.tar.gz"
    sha256 "607774cbba28732bfa802b54baa7484215f530991055bb562efbed5b2f20a45e"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"schema.yaml").write <<~EOS
      string: str()
      number: num(required=False)
      datetime: timestamp(min='2010-01-01 0:0:0')
    EOS
    (testpath/"data1.yaml").write <<~EOS
      string: bo is awesome
      datetime: 2011-01-01 00:00:00
    EOS
    (testpath/"some_data.yaml").write <<~EOS
      string: one
      number: 3
      datetime: 2015-01-01 00:00:00
    EOS
    output = shell_output("#{bin}/yamale -s schema.yaml data1.yaml")
    assert_match "Validation success!", output

    output = shell_output("#{bin}/yamale -s schema.yaml some_data.yaml")
    assert_match "Validation success!", output

    (testpath/"good.yaml").write <<~EOS
      ---
      foo: bar
    EOS
    output = shell_output("#{bin}/yamale -s schema.yaml schema.yaml", 1)
    assert_match "Validation failed!", output
  end
end
