class Showcert < Formula
  include Language::Python::Virtualenv

  desc "X.509 TLS certificate reader and creator"
  homepage "https://github.com/yaroslaff/showcert"
  url "https://files.pythonhosted.org/packages/da/8c/c697a22f71578fa7ebb2769ab7a8abb651f68f9a9d5719b07d4b80a7bf31/showcert-0.4.4.tar.gz"
  sha256 "cd59abab0de0f5541be2503cdeb700bbb2fb744906d28ef57c7e51d3bc2cdfce"
  license "MIT"
  head "https://github.com/yaroslaff/showcert.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "90da77181390c80f50fae6279781ce216edb21fa4bbfa594c4bb1b7feca6d5aa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "90da77181390c80f50fae6279781ce216edb21fa4bbfa594c4bb1b7feca6d5aa"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "90da77181390c80f50fae6279781ce216edb21fa4bbfa594c4bb1b7feca6d5aa"
    sha256 cellar: :any_skip_relocation, sonoma:        "d91dcebe3a3b89859fb266969c92e1c9202fa7e1082fe2d6b45be5b0de2e968a"
    sha256 cellar: :any_skip_relocation, ventura:       "d91dcebe3a3b89859fb266969c92e1c9202fa7e1082fe2d6b45be5b0de2e968a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ef20a912af681275e185e39900726edd3fb67fb6336f5a93bef85780b802f1fc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ef20a912af681275e185e39900726edd3fb67fb6336f5a93bef85780b802f1fc"
  end

  depends_on "certifi"
  depends_on "cryptography"
  depends_on "libmagic"
  depends_on "python@3.13"

  resource "pem" do
    url "https://files.pythonhosted.org/packages/05/86/16c0b6789816f8d53f2f208b5a090c9197da8a6dae4d490554bb1bedbb09/pem-23.1.0.tar.gz"
    sha256 "06503ff2441a111f853ce4e8b9eb9d5fedb488ebdbf560115d3dd53a1b4afc73"
  end

  resource "pyopenssl" do
    url "https://files.pythonhosted.org/packages/04/8c/cd89ad05804f8e3c17dea8f178c3f40eeab5694c30e0c9f5bcd49f576fc3/pyopenssl-25.1.0.tar.gz"
    sha256 "8d031884482e0c67ee92bf9a4d8cceb08d92aba7136432ffb0703c5280fc205b"
  end

  resource "python-magic" do
    url "https://files.pythonhosted.org/packages/da/db/0b3e28ac047452d079d375ec6798bf76a036a08182dbb39ed38116a49130/python-magic-0.4.27.tar.gz"
    sha256 "c1ba14b08e4a5f5c31a302b7721239695b2f0f058d125bd5ce1ee36b9d9d3c3b"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/showcert -h")

    assert_match "O=Let's Encrypt", shell_output("#{bin}/showcert brew.sh")

    assert_match version.to_s, shell_output("#{bin}/gencert -h")

    system bin/"gencert", "--ca", "Homebrew"
    assert_path_exists testpath/"Homebrew.key"
    assert_path_exists testpath/"Homebrew.pem"
  end
end
