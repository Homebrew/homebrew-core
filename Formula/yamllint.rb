class Yamllint < Formula
  include Language::Python::Virtualenv

  desc "Linter for YAML files"
  homepage "https://github.com/adrienverge/yamllint"
  url "https://files.pythonhosted.org/packages/9d/3d/f313c341f0592d23bd7dfe24e46af0d16a796cd865d5ac0041bb200f9cc4/yamllint-1.26.3.tar.gz"
  sha256 "3934dcde484374596d6b52d8db412929a169f6d9e52e20f9ade5bf3523d9b96e"
  license "GPL-3.0-or-later"
  revision 1
  head "https://github.com/adrienverge/yamllint.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "911640068e7b2b37bbbf751215cda40f5a5b0ed80c97bd4359f0b32afb16a402"
    sha256 cellar: :any,                 arm64_big_sur:  "5376ecd78f62bee66a8fa4a2f06a5aba1fb71f1fccd8069f2b7bfd68eaad12db"
    sha256 cellar: :any,                 monterey:       "c9ed4fc531a4aa44e4b0d68ed412c1084e45115dd446ca4f0ecfd7ddd916ff04"
    sha256 cellar: :any,                 big_sur:        "1d742d4e3e0298bcda9cd6a17047439436060197ade03656aa27db97e3dfe718"
    sha256 cellar: :any,                 catalina:       "e9496ce883729cfd2afbf531d77ba00f1c3924d4c89fe9e244ea5e540a360b66"
    sha256 cellar: :any,                 mojave:         "dd176ec514dffdd661b50e96d0ad9e9d15a67c23b666df56ea8034f3f5084500"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "86d7f660931b052e940018cc8df336be380190d65b8b12cfbb17ec52a6227b82"
  end

  depends_on "libyaml"
  depends_on "python@3.10"

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
