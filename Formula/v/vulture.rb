class Vulture < Formula
  include Language::Python::Virtualenv

  desc "Find dead Python code"
  homepage "https://github.com/jendrikseipp/vulture"
  url "https://files.pythonhosted.org/packages/f8/12/a4f70dc86015a76d66785e2dbc3a03e00fb6ff70a4d039dd8ed14a9df03a/vulture-2.8.tar.gz"
  sha256 "393293f183508064294b0feb4c8579e7f1f27e5bf74c9def6a3d52f38b29b599"
  license "MIT"
  head "https://github.com/jendrikseipp/vulture.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "28808ad1470a0e3cadfcb63cf68c82921e6fda0c04789454890428b314cfcd89"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cabacd95b9c2e0bac4a37b4459bf310363a0b169dab7553aa3abf2368b5a8785"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e8eb7af91c80458509ff157b57f50d0297d638b14979878664257d53c5135e57"
    sha256 cellar: :any_skip_relocation, ventura:        "225a367c4a920558f7b33772c5ef35aab23bedb44dffcd42870746794d97100d"
    sha256 cellar: :any_skip_relocation, monterey:       "3e20bcd278282381534e85376fb858417953066f78d1f05e9e9c7357075c53d6"
    sha256 cellar: :any_skip_relocation, big_sur:        "e6e8de8bb8050d860550b864a0ff6795ca2b34d25ae5e244dc47c4da768055ba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ef1619b88935c28ab2eb778554513f85b83da6df870fe52a43aaf08be202d5fc"
  end

  depends_on "python-toml"
  depends_on "python@3.11"

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_equal "vulture #{version}\n", shell_output("#{bin}/vulture --version")
    (testpath/"unused.py").write "class Unused: pass"
    assert_match "unused.py:1: unused class 'Unused'", shell_output("#{bin}/vulture #{testpath}/unused.py", 1)
    (testpath/"used.py").write "print(1+1)"
    assert_empty shell_output("#{bin}/vulture #{testpath}/used.py")
  end
end
