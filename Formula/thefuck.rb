class Thefuck < Formula
  include Language::Python::Virtualenv

  desc "Programatically correct mistyped console commands"
  homepage "https://github.com/nvbn/thefuck"
  url "https://files.pythonhosted.org/packages/87/f1/d159c8351b4220384630904cb13bded28f1564eaef7f9a0eb6d3080487a6/thefuck-3.15.tar.gz"
  sha256 "c1da9f9b705c864362316de34a1494df0c803699e587e6cf925407e42966b4aa"
  head "https://github.com/nvbn/thefuck.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "67320d3b0448561d871484eaa3ed7f449d8c1b46f79e33223a5f8394446089be" => :sierra
    sha256 "482521f11c9a464d83b639f7bebcdf16a3d16ed851e14174a3d81c84a64cb40a" => :el_capitan
    sha256 "1ef7264271dc63f64cf6bcf69112dbbd1d4fa1803b7cafc4b8d83f82061e04ed" => :yosemite
  end

  depends_on :python if MacOS.version <= :snow_leopard

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/f0/d0/21c6449df0ca9da74859edc40208b3a57df9aca7323118c913e58d442030/colorama-0.3.7.tar.gz"
    sha256 "e043c8d32527607223652021ff648fbb394d5e19cba9f1a698670b338c9d782b"
  end

  resource "decorator" do
    url "https://files.pythonhosted.org/packages/13/8a/4eed41e338e8dcc13ca41c94b142d4d20c0de684ee5065523fee406ce76f/decorator-4.0.10.tar.gz"
    sha256 "9c6e98edcb33499881b86ede07d9968c81ab7c769e28e9af24075f0a5379f070"
  end

  resource "pathlib2" do
    url "https://files.pythonhosted.org/packages/7e/29/8f106fbb7e00db38dd94512041fe17ac368f0738f369fd24ed0c2e9137e3/pathlib2-2.2.0.tar.gz"
    sha256 "a34e82120e503ebeee9e4c4f6a6f199b117a58819d18ed0c7f8cc944d435086b"
  end

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/d9/c8/8c7a2ab8ec108ba9ab9a4762c5a0d67c283d41b13b5ce46be81fdcae3656/psutil-5.0.1.tar.gz"
    sha256 "9d8b7f8353a2b2eb6eb7271d42ec99d0d264a9338a37be46424d56b4e473b39e"
  end

  resource "scandir" do
    url "https://files.pythonhosted.org/packages/95/40/ddbcd295ee58d5c1126645890bcf87853e4075547308884e4f8ada27f195/scandir-1.4.tar.gz"
    sha256 "ada8d3ddc82fd168b3f46feb393d37c722ed0553a10a3ce5426ddc5ec17d597a"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/b3/b2/238e2590826bfdd113244a40d9d3eb26918bd798fc187e2360a8367068db/six-1.10.0.tar.gz"
    sha256 "105f8d68616f8248e24bf0e9372ef04d3cc10104f1980f54d57b2ce73a5ad56a"
  end

  def install
    virtualenv_install_with_resources
  end

  def caveats; <<-EOS.undent
    Add the following to your .bash_profile, .bashrc or .zshrc:

      eval "$(thefuck --alias)"

    For other shells, check https://github.com/nvbn/thefuck/wiki/Shell-aliases
    EOS
  end

  test do
    ENV["THEFUCK_REQUIRE_CONFIRMATION"] = "false"

    output = shell_output("#{bin}/thefuck --version 2>&1")
    assert_match "The Fuck #{version} using Python", output

    output = shell_output("#{bin}/thefuck --alias")
    assert_match /.+TF_ALIAS.+thefuck.+/, output

    output = shell_output("#{bin}/thefuck git branchh")
    assert_equal "git branch", output.chomp

    output = shell_output("#{bin}/thefuck echho ok")
    assert_equal "echo ok", output.chomp

    output = shell_output("#{bin}/fuck")
    assert_match "Seems like fuck alias isn't configured!", output
  end
end
