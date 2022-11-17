class Waybackpy < Formula
  include Language::Python::Virtualenv

  desc "Wayback Machine API interface & command-line tool"
  homepage "https://pypi.org/project/waybackpy/"
  url "https://files.pythonhosted.org/packages/34/ab/90085feb81e7fad7d00c736f98e74ec315159ebef2180a77c85a06b2f0aa/waybackpy-3.0.6.tar.gz"
  sha256 "497a371756aba7644eb7ada0ebd4edb15cb8c53bc134cc973bf023a12caff83f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6b6d17e9bfb4e1f90f2daddefcb17ae0bd9c82c8f654961a15f2c13a98870c1c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "79e87c92ff4985b256447d0ca7bd699fb4df8b204ece99189e49e235aac18cbc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "11b989acd04645a2f19d7e03d08c3d6d26b85e1be257157d806277104204dd85"
    sha256 cellar: :any_skip_relocation, ventura:        "2bb76dc670ab4c289b1c9eb6845dfe9db09b27821b6476b558078bec219a0229"
    sha256 cellar: :any_skip_relocation, monterey:       "83a9011013ab8c19a18def73a89443d32825b19a8511638ea18aa2723b08b678"
    sha256 cellar: :any_skip_relocation, big_sur:        "b87cdf6a11c5c03affe1c186c4778482956c4b1964ab47834193c2786474569e"
    sha256 cellar: :any_skip_relocation, catalina:       "b0ab0c34fe4b41deb32948c04851a4211c92d1debc0bbef6d297840229b0f0d9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7ffb457c20e944760b8ecd3f95112969835814a34dba2685cb035ab163b3a41d"
  end

  depends_on "python@3.10"

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/cb/a4/7de7cd59e429bd0ee6521ba58a75adaec136d32f91a761b28a11d8088d44/certifi-2022.9.24.tar.gz"
    sha256 "0d9c601124e5a6ba9712dbc60d9c53c21e34f5f641fe83002317394311bdce14"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/a1/34/44964211e5410b051e4b8d2869c470ae8a68ae274953b1c7de6d98bbcf94/charset-normalizer-2.1.1.tar.gz"
    sha256 "5a3d016c7c547f69d6f81fb0db9449ce888b418b5b9952cc5e6e66843e9dd845"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/59/87/84326af34517fca8c58418d148f2403df25303e02736832403587318e9e8/click-8.1.3.tar.gz"
    sha256 "7682dc8afb30297001674575ea00d1814d808d6a36af415a82bd481d37ba7b8e"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/8b/e1/43beb3d38dba6cb420cefa297822eac205a277ab43e5ba5d5c46faf96438/idna-3.4.tar.gz"
    sha256 "814f528e8dead7d329833b91c5faa87d60bf71824cd12a7530b5526063d02cb4"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/a5/61/a867851fd5ab77277495a8709ddda0861b28163c4613b011bc00228cc724/requests-2.28.1.tar.gz"
    sha256 "7c5599b102feddaa661c826c56ab4fee28bfd17f5abca1ebbe3e7f19d7c97983"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/b2/56/d87d6d3c4121c0bcec116919350ca05dc3afd2eeb7dc88d07e8083f8ea94/urllib3-1.26.12.tar.gz"
    sha256 "3fa96cf423e6987997fc326ae8df396db2a8b7c667747d47ddd8ecba91f4a74e"
  end

  def install
    virtualenv_install_with_resources
    bin.install_symlink libexec/"bin/waybackpy"
  end

  test do
    output = shell_output("#{bin}/waybackpy -o --url https://brew.sh")
    assert_match "20130328163936", output
  end
end
