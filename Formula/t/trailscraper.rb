class Trailscraper < Formula
  include Language::Python::Virtualenv

  desc "Tool to get valuable information out of AWS CloudTrail"
  homepage "https://github.com/flosell/trailscraper"
  url "https://files.pythonhosted.org/packages/bc/9b/f425ff02c84a16e434526d3ffe7abfc50589f46a5efe9b02cfd09bec698e/trailscraper-0.8.1.tar.gz"
  sha256 "fe0f7970554a7100be6a4dc6ecce0ce0f4a5a3337a689e7035df7ac3c37ec21a"
  license "Apache-2.0"
  revision 2
  head "https://github.com/flosell/trailscraper.git", branch: "master"

  bottle do
    rebuild 4
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cd0ec97421ffa49e8f3d5069d79e3b4ffb9214acaf1b951fd2eabf3a6a6e4e27"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "521aae285c1a793932d474b040cc0167cd6ee31d965cfd5064d596aa8b130077"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "71d57665f463074c756a6c780cc285810d6b8471fba9f8110d2b45994a34a3b1"
    sha256 cellar: :any_skip_relocation, sonoma:        "1ac8f22cfc1a54aef3825b4c31a8c08ed48fa248578159e69cdcdce67b5a3846"
    sha256 cellar: :any_skip_relocation, ventura:       "db4b10aa820f732bd4bed212416e56b7327b80289f7ad37f43ad03b315e28f62"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9bf1f71cec5893540354ebd8a0779b22ad7da4c829ce5e308a31d1ee7bdf40fe"
  end

  depends_on "python@3.13"

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/95/60/88c7932476b438fc4702daa0dc6f5663c8c1451898d3d7daa0f934468086/boto3-1.26.54.tar.gz"
    sha256 "4e876ba5d64928cde0c416dd844f04f22d6b73d14002bbc3ca55591f80f49927"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/3d/f6/d35a27c73dc1053abdfe8524d1e488073fccb51e43c88da61b8fe29522e3/botocore-1.29.165.tar.gz"
    sha256 "988b948be685006b43c4bbd8f5c0cb93e77c66deb70561994e0c5b31b5a67210"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/59/87/84326af34517fca8c58418d148f2403df25303e02736832403587318e9e8/click-8.1.3.tar.gz"
    sha256 "7682dc8afb30297001674575ea00d1814d808d6a36af415a82bd481d37ba7b8e"
  end

  resource "dateparser" do
    url "https://files.pythonhosted.org/packages/bb/2d/2f5dc79f80623f0f7ec4ee5291512caffda18f3ea070cb2775cc7839733f/dateparser-1.1.6.tar.gz"
    sha256 "e703db1815270c020552f4b3e3a981937b48b2cbcfcef5347071b74788dd9214"
  end

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/00/2a/e867e8531cf3e36b41201936b7fa7ba7b5702dbef42922193f05c8976cd6/jmespath-1.0.1.tar.gz"
    sha256 "90261b206d6defd58fdd5e85f478bf633a2901798906be2ad389150c5c60edbe"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/66/c0/0c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6db/python-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "pytz" do
    url "https://files.pythonhosted.org/packages/03/3e/dc5c793b62c60d0ca0b7e58f1fdd84d5aaa9f8df23e7589b39cc9ce20a03/pytz-2022.7.1.tar.gz"
    sha256 "01a0681c4b9684a28304615eba55d1ab31ae00bf68ec157ec3708a8182dbbcd0"
  end

  resource "regex" do
    url "https://files.pythonhosted.org/packages/f9/38/148df33b4dbca3bd069b963acab5e0fa1a9dbd6820f8c322d0dd6faeff96/regex-2024.9.11.tar.gz"
    sha256 "6c188c307e8433bcb63dc1915022deb553b4203a70722fc542c363bf120a01fd"
  end

  resource "ruamel-yaml" do
    url "https://files.pythonhosted.org/packages/46/a9/6ed24832095b692a8cecc323230ce2ec3480015fbfa4b79941bd41b23a3c/ruamel.yaml-0.17.21.tar.gz"
    sha256 "8b7ce697a2f212752a35c1ac414471dc16c424c9573be4926b56ff3f5d23b7af"
  end

  resource "s3transfer" do
    url "https://files.pythonhosted.org/packages/5a/47/d676353674e651910085e3537866f093d2b9e9699e95e89d960e78df9ecf/s3transfer-0.6.2.tar.gz"
    sha256 "cab66d3380cca3e70939ef2255d01cd8aece6a4907a9528740f668c4b0611861"
  end

  # setuptools explicitly added due to https://github.com/flosell/trailscraper/issues/602
  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/27/b8/f21073fde99492b33ca357876430822e4800cdf522011f18041351dfa74b/setuptools-75.1.0.tar.gz"
    sha256 "d59a21b17a275fb872a9c3dae73963160ae079f1049ed956880cd7c09b120538"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/71/39/171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85e/six-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

  resource "toolz" do
    url "https://files.pythonhosted.org/packages/cf/05/2008534bbaa716b46a2d795d7b54b999d0f7638fbb9ed0b6e87bfa934f84/toolz-0.12.0.tar.gz"
    sha256 "88c570861c440ee3f2f6037c4654613228ff40c93a6c25e0eba70d17282c6194"
  end

  resource "tzlocal" do
    url "https://files.pythonhosted.org/packages/04/d3/c19d65ae67636fe63953b20c2e4a8ced4497ea232c43ff8d01db16de8dc0/tzlocal-5.2.tar.gz"
    sha256 "8d399205578f1a9342816409cc1e46a93ebd5755e39ea2d85334bea911bf0e6e"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/e4/e8/6ff5e6bc22095cfc59b6ea711b687e2b7ed4bdb373f7eeec370a97d7392f/urllib3-1.26.20.tar.gz"
    sha256 "40c2dc0c681e47eb8f90e7e27bf6ff7df2e677421fd46756da1161c39ca70d32"
  end

  def install
    virtualenv_install_with_resources

    generate_completions_from_executable(bin/"trailscraper", shells: [:fish, :zsh], shell_parameter_format: :click)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/trailscraper --version")

    test_input = '{"Records": []}'
    output = pipe_output("#{bin}/trailscraper generate", test_input)
    assert_match "Statement", output
  end
end
