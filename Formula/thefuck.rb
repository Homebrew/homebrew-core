class Thefuck < Formula
  include Language::Python::Virtualenv

  desc "Programatically correct mistyped console commands"
  homepage "https://github.com/nvbn/thefuck"
  url "https://files.pythonhosted.org/packages/ec/20/3f136313c27ea36ba38d31818b9f0a1a4656668fc6747b3bfa04f3debc98/thefuck-3.25.tar.gz"
  sha256 "70cbe6295d2d2d371a395619216d38eb1666e4b3c3b1a24f67d11b88e65fea78"
  head "https://github.com/nvbn/thefuck.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "85c7af988c0081a2727b9659da57491077879341efc35986c55dc0b06f12176c" => :high_sierra
    sha256 "f81a57481dd119f21377ac1f7fbf341c8102fd6c493742526602f6ae3b976da4" => :sierra
    sha256 "e38c62f20f99893728847e9a99c986ddcb5237ebf9265aff0ee9925150089b0a" => :el_capitan
  end

  depends_on :python3

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/e6/76/257b53926889e2835355d74fec73d82662100135293e17d382e2b74d1669/colorama-0.3.9.tar.gz"
    sha256 "48eb22f4f8461b1df5734a074b57042430fb06e1d61bd1e11b078c0fe6d7a1f1"
  end

  resource "decorator" do
    url "https://files.pythonhosted.org/packages/bb/e0/f6e41e9091e130bf16d4437dabbac3993908e4d6485ecbc985ef1352db94/decorator-4.1.2.tar.gz"
    sha256 "7cb64d38cb8002971710c8899fbdfb859a23a364b7c99dab19d1f719c2ba16b5"
  end

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/fe/17/0f0bf5792b2dfe6003efc5175c76225f7d3426f88e2bf8d360cfab870cd8/psutil-5.4.1.tar.gz"
    sha256 "42e2de159e3c987435cb3b47d6f37035db190a1499f3af714ba7af5c379b6ba2"
  end

  resource "pyte" do
    url "https://files.pythonhosted.org/packages/d2/1c/f65766736e40916b9a27c6cd582313e78092501b68284d44a1b014f30230/pyte-0.7.0.tar.gz"
    sha256 "873acb47b624b9f30e9c54fab9c06a53be3b6bfa4b3d863ab30f55e93724c5aa"
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
