class Thefuck < Formula
  include Language::Python::Virtualenv

  desc "Programatically correct mistyped console commands"
  homepage "https://github.com/nvbn/thefuck"
  url "https://files.pythonhosted.org/packages/46/ed/11176f81a85876f4016c18907d6e085862df464a76628b91b3e91f080c7e/thefuck-3.30.tar.gz"
  sha256 "32b41db4360a810d8e761e80fe09868ce634476ee1829e26869d49484b7a95cc"
  head "https://github.com/nvbn/thefuck.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "9101f88f96d66615970b00405f06430176fb827922363530abb33f3d22341ff3" => :catalina
    sha256 "fde50d03f97cf18dbdf89d86469f7c7c2794d40e639ad3c2c926466b98e455ee" => :mojave
    sha256 "272cc963d34074daf27ca24dcb16f7f2a47aaafe955ff0e259dd38191274d1d1" => :high_sierra
  end

  depends_on "python@3.8"

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/82/75/f2a4c0c94c85e2693c229142eb448840fba0f9230111faa889d1f541d12d/colorama-0.4.3.tar.gz"
    sha256 "e96da0d330793e2cb9485e9ddfd918d456036c7149416295932478192f4436a1"
  end

  resource "decorator" do
    url "https://files.pythonhosted.org/packages/da/93/84fa12f2dc341f8cf5f022ee09e109961055749df2d0c75c5f98746cfe6c/decorator-4.4.2.tar.gz"
    sha256 "e3a62f0520172440ca0dcc823749319382e377f37f140a0b99ef45fecb84bfe7"
  end

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/c4/b8/3512f0e93e0db23a71d82485ba256071ebef99b227351f0f5540f744af41/psutil-5.7.0.tar.gz"
    sha256 "685ec16ca14d079455892f25bd124df26ff9137664af445563c1bd36629b5e0e"
  end

  resource "pyte" do
    url "https://files.pythonhosted.org/packages/66/37/6fed89b484c8012a0343117f085c92df8447a18af4966d25599861cd5aa0/pyte-0.8.0.tar.gz"
    sha256 "7e71d03e972d6f262cbe8704ff70039855f05ee6f7ad9d7129df9c977b5a88c5"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/21/9f/b251f7f8a76dec1d6651be194dfba8fb8d7781d10ab3987190de8391d08e/six-1.14.0.tar.gz"
    sha256 "236bdbdce46e6e6a3d61a337c0f8b763ca1e8717c03b369e87a7ec7ce1319c0a"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/5e/33/92333eb80be0c96385dee338f30b53e24a8b415d5785e225d789b3f90feb/wcwidth-0.1.8.tar.gz"
    sha256 "f28b3e8a6483e5d49e7f8949ac1a78314e740333ae305b4ba5defd3e74fb37a8"
  end

  def install
    virtualenv_install_with_resources
  end

  def caveats
    <<~EOS
      Add the following to your .bash_profile, .bashrc or .zshrc:

        eval $(thefuck --alias)

      For other shells, check https://github.com/nvbn/thefuck/wiki/Shell-aliases
    EOS
  end

  test do
    ENV["THEFUCK_REQUIRE_CONFIRMATION"] = "false"
    ENV["LC_ALL"] = "en_US.UTF-8"

    output = shell_output("#{bin}/thefuck --version 2>&1")
    assert_match "The Fuck #{version} using Python", output

    output = shell_output("#{bin}/thefuck --alias")
    assert_match "TF_ALIAS=fuck", output

    output = shell_output("#{bin}/thefuck git branchh")
    assert_equal "git branch", output.chomp

    output = shell_output("#{bin}/thefuck echho ok")
    assert_equal "echo ok", output.chomp

    output = shell_output("#{bin}/fuck")
    assert_match "Seems like fuck alias isn't configured!", output
  end
end
