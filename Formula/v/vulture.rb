class Vulture < Formula
  include Language::Python::Virtualenv

  desc "Find dead Python code"
  homepage "https://github.com/jendrikseipp/vulture"
  url "https://files.pythonhosted.org/packages/4c/5d/4734f4808f63e8b7897cef965a5413e94845eafbc256f70126c0c462a84d/vulture-2.9.1.tar.gz"
  sha256 "b6a2aa632b6fd51488a8eeac650ab4a509bb1a032e81943817a8a2e6a63a30b3"
  license "MIT"
  head "https://github.com/jendrikseipp/vulture.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "810b7b778416c4e803aeff1b667136c07ed49028aea3e4a60ea949f7203c36a2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f8c4d69446eb8399b5946a674a173a5385d18eb8c1905bb841276ef6abcadc7d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0e280dc6445c2a24fb8bd88a44ea672eda8d758f33387205ca54016040d85069"
    sha256 cellar: :any_skip_relocation, ventura:        "509e428b7465d021fe292aaa04b1436c47ca5b0cc8e380f6678e5a0938f719b1"
    sha256 cellar: :any_skip_relocation, monterey:       "9e517bb3ac2b5e594cdadb02cb315efc76aa30b23f0d8cb247e13716b2ad6437"
    sha256 cellar: :any_skip_relocation, big_sur:        "9b8be202d1fcce0c4527f2943c630b354ffc11509098e70f86efb0a05ed3710e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ad9d61521203bae3f98d338df3ff10cd1f9f46bc12996f90394863d0aff5432a"
  end

  depends_on "python-toml"
  depends_on "python@3.11"

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_equal "vulture #{version}\n", shell_output("#{bin}/vulture --version")

    (testpath/"unused.py").write "class Unused: pass"
    assert_match "unused.py:1: unused class 'Unused'", shell_output("#{bin}/vulture #{testpath}/unused.py", 3)
    (testpath/"used.py").write "print(1+1)"
    assert_empty shell_output("#{bin}/vulture #{testpath}/used.py")
  end
end
