class Vermin < Formula
  include Language::Python::Virtualenv

  desc "Concurrently detect the minimum Python versions needed to run code"
  homepage "https://github.com/netromdk/vermin"
  url "https://files.pythonhosted.org/packages/3d/26/7b871396c33006c445c25ef7da605ecbd6cef830d577b496d2b73a554f9d/vermin-1.6.0.tar.gz"
  sha256 "6266ca02f55d1c2aa189a610017c132eb2d1934f09e72a955b1eb3820ee6d4ef"
  license "MIT"
  head "https://github.com/netromdk/vermin.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, all: "e25e54e3725d3f470d93f8272ac428d145eb667beb966d31498d02fee48be0c3"
  end

  depends_on "python@3.13"

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
