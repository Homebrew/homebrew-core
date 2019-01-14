class Thefuck < Formula
  include Language::Python::Virtualenv

  desc "Programatically correct mistyped console commands"
  homepage "https://github.com/nvbn/thefuck"
  url "https://files.pythonhosted.org/packages/79/5e/a8a5ae5bfbe14f6ec01b1b9cee68383b1ff71e59be41a8923e3290c6fc21/thefuck-3.28.tar.gz"
  sha256 "cc123eb1e6962d315b777db286e6a172231f02eff00ab340fdd38c4504badc3a"
  head "https://github.com/nvbn/thefuck.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "ba156420e76de319599e62504d73aef820ff06a8d363e5c6501124dd71337c76" => :mojave
    sha256 "5c4e966a4939ae0a6cf59b7f544656c87d98dd98cae7b645b6a0e1cb3538eda1" => :high_sierra
    sha256 "4829a8bb95a312c52a996b0cb4a6520bebc2c464391dd0eb3b08572dddc7a8ab" => :sierra
  end

  depends_on "python"

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/e6/76/257b53926889e2835355d74fec73d82662100135293e17d382e2b74d1669/colorama-0.3.9.tar.gz"
    sha256 "48eb22f4f8461b1df5734a074b57042430fb06e1d61bd1e11b078c0fe6d7a1f1"
  end

  resource "decorator" do
    url "https://files.pythonhosted.org/packages/6f/24/15a229626c775aae5806312f6bf1e2a73785be3402c0acdec5dbddd8c11e/decorator-4.3.0.tar.gz"
    sha256 "c39efa13fbdeb4506c476c9b3babf6a718da943dab7811c206005a4a956c080c"
  end

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/14/a2/8ac7dda36eac03950ec2668ab1b466314403031c83a95c5efc81d2acf163/psutil-5.4.5.tar.gz"
    sha256 "ebe293be36bb24b95cdefc5131635496e88b17fabbcf1e4bc9b5c01f5e489cfe"
  end

  resource "pyte" do
    url "https://files.pythonhosted.org/packages/66/37/6fed89b484c8012a0343117f085c92df8447a18af4966d25599861cd5aa0/pyte-0.8.0.tar.gz"
    sha256 "7e71d03e972d6f262cbe8704ff70039855f05ee6f7ad9d7129df9c977b5a88c5"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/16/d8/bc6316cf98419719bd59c91742194c111b6f2e85abac88e496adefaf7afe/six-1.11.0.tar.gz"
    sha256 "70e8a77beed4562e7f14fe23a786b54f6296e34344c23bc42f07b15018ff98e9"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/55/11/e4a2bb08bb450fdbd42cc709dd40de4ed2c472cf0ccb9e64af22279c5495/wcwidth-0.1.7.tar.gz"
    sha256 "3df37372226d6e63e1b1e1eda15c594bca98a22d33a23832a90998faa96bc65e"
  end

  def install
    virtualenv_install_with_resources
  end

  def caveats; <<~EOS
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
