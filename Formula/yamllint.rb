class Yamllint < Formula
  include Language::Python::Virtualenv

  desc "Linter for YAML files"
  homepage "https://github.com/adrienverge/yamllint"
  url "https://github.com/adrienverge/yamllint/archive/v1.20.0.tar.gz"
  sha256 "6391bfd0f3d360a418fef54c6ccf77615c25b2b62c54fb770c07823471016b18"
  revision 2

  bottle do
    cellar :any
    sha256 "c9af991306882a4fe21500a52a63d6e110d09e9c4ba6c9da2558a99bdcfcce8f" => :catalina
    sha256 "1aee52bbc89a796c87eb838ec79de9f2d7e1ea371bf64bd4ca70b430966f8360" => :mojave
    sha256 "16ff7600ad8d42d077f931bbd968ee41425e1a6c6a9e5fd4f827e83ca5b40bf1" => :high_sierra
  end

  depends_on "libyaml"
  depends_on "python@3.8"

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/3d/d9/ea9816aea31beeadccd03f1f8b625ecf8f645bd66744484d162d84803ce5/PyYAML-5.3.tar.gz"
    sha256 "e9f45bd5b92c7974e59bcd2dcc8631a6b6cc380a904725fce7bc08872e691615"
  end

  resource "pathspec" do
    url "https://files.pythonhosted.org/packages/ce/f2/d35c292da8fbff725625a17ae40f48f933070acd5ccddb03d8c09d81758d/pathspec-0.7.0.tar.gz"
    sha256 "562aa70af2e0d434367d9790ad37aed893de47f1693e4201fd1d3dca15d19b96"
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
