class Vermin < Formula
  include Language::Python::Virtualenv

  desc "Concurrently detect the minimum Python versions needed to run code"
  homepage "https://github.com/netromdk/vermin"
  url "https://files.pythonhosted.org/packages/3f/e2/ec751ab6385d29be7a8d7a54379fa7d3267440c55dde0f265a0730417027/vermin-1.9.2.tar.gz"
  sha256 "ba4e01ab817c6baadf5f057bd6ea691e1147bcaf00c1ac8db54df0e25c6d2c6d"
  license "MIT"
  head "https://github.com/netromdk/vermin.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "1f1c520e383f4d4dc145217f5fabf02c1ac4c6b9e16fd2b047667fc337713eb6"
  end

  depends_on "python@3.15"

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_equal <<~EOS, shell_output("#{bin}/vermin --no-parse-comments #{bin}/vermin")
      Minimum required versions: ~2, ~3
      Note: Not enough evidence to conclude it won't work with Python 2 or 3.
    EOS

    assert_match version.to_s, shell_output("#{bin}/vermin --version")
  end
end
