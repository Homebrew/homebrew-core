class Vermin < Formula
  include Language::Python::Virtualenv

  desc "Concurrently detect the minimum Python versions needed to run code"
  homepage "https://github.com/netromdk/vermin"
  url "https://files.pythonhosted.org/packages/24/7b/2c1b403f2a844e1acb36694fc336e323df742f7f752edb4188311ad43f9e/vermin-1.8.0.tar.gz"
  sha256 "3621955ac2a2950175c5b4a9b2fc3bd24bd416da0388893c9eb6971264e4ca1f"
  license "MIT"
  head "https://github.com/netromdk/vermin.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "0ec82df48d8d1c8e0793fd34b3217b2d11a572c624ab770b4c2adaa7e1d6e5a4"
  end

  depends_on "python@3.14"

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
