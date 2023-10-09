class Vulture < Formula
  include Language::Python::Virtualenv

  desc "Find dead Python code"
  homepage "https://github.com/jendrikseipp/vulture"
  url "https://files.pythonhosted.org/packages/ba/1a/d4154700ed512e5274ef923b4281e5a33a3da107a6c609e0e5c68be9355c/vulture-2.10.tar.gz"
  sha256 "2a5c3160bffba77595b6e6dfcc412016bd2a09cd4b66cdf7fbba913684899f6f"
  license "MIT"
  head "https://github.com/jendrikseipp/vulture.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "099c05da8a85d292fa1af8c531c0fe6ebf0443d93dcbd8a47b2a89924a01e676"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8b49ff8ae702edb3bb71e825ae3c65783cc6ba7b4a9d11a809ed90e026d0a5a6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1eb34011febc9a4456dc4f275d64368b9fa8b425de0f6e45b87ecc3dca49921b"
    sha256 cellar: :any_skip_relocation, sonoma:         "cc83b5bfb616d2f23c54810d0f477bafe41911cf32abd506a8e8d1a3b5ab41b1"
    sha256 cellar: :any_skip_relocation, ventura:        "91d4c8fc701cb8942239e5b65202802800cb74f51180e80f0ae57d96c6b67e51"
    sha256 cellar: :any_skip_relocation, monterey:       "9a253e2a0e8b09ebd9ed163ba66feba6c337ba68f0a1a53bc8f25da2262a6a97"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9031a64a92ce9200bdb23264577a9bae8f6629c35e93f4231142e94f2a10fbc2"
  end

  depends_on "python-toml"
  depends_on "python@3.12"

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
