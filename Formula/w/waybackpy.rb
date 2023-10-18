class Waybackpy < Formula
  include Language::Python::Virtualenv

  desc "Wayback Machine API interface & command-line tool"
  homepage "https://pypi.org/project/waybackpy/"
  url "https://files.pythonhosted.org/packages/34/ab/90085feb81e7fad7d00c736f98e74ec315159ebef2180a77c85a06b2f0aa/waybackpy-3.0.6.tar.gz"
  sha256 "497a371756aba7644eb7ada0ebd4edb15cb8c53bc134cc973bf023a12caff83f"
  license "MIT"
  revision 2

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "13812cda049e09fbddf86a15b5410684d5efc9a2ac5973a2538deed3887e00c4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c343d03448321aadda29273f7cc5ee27f53625d81b8287c74ced4fcd709644a2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3111f1fda42ae05e8b42b789aabb8691b7fa0799a589b2df9f322259cb2519d9"
    sha256 cellar: :any_skip_relocation, sonoma:         "a033a78eafa754e4843cf601624e7b55a76e3cf41b3a7bcbff4464f7929af266"
    sha256 cellar: :any_skip_relocation, ventura:        "7d9efd6afff45082317c96ee362b29479261feae37881be5191328cf193a0160"
    sha256 cellar: :any_skip_relocation, monterey:       "c0162c2a196ae868aabae0ee7339254c7d9ca4bbb65b77094f6ef412d82e4536"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1039778de05dacd7b72ba940e30fca0c44a8ed6b214e7a7eb7367b8647511712"
  end

  depends_on "python-certifi"
  depends_on "python-click"
  depends_on "python@3.12"

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/cf/ac/e89b2f2f75f51e9859979b56d2ec162f7f893221975d244d8d5277aa9489/charset-normalizer-3.3.0.tar.gz"
    sha256 "63563193aec44bce707e0c5ca64ff69fa72ed7cf34ce6e11d5127555756fd2f6"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/8b/e1/43beb3d38dba6cb420cefa297822eac205a277ab43e5ba5d5c46faf96438/idna-3.4.tar.gz"
    sha256 "814f528e8dead7d329833b91c5faa87d60bf71824cd12a7530b5526063d02cb4"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/9d/be/10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3/requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/8b/00/db794bb94bf09cadb4ecd031c4295dd4e3536db4da958e20331d95f1edb7/urllib3-2.0.6.tar.gz"
    sha256 "b19e1a85d206b56d7df1d5e683df4a7725252a964e3993648dd0fb5a1c157564"
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
