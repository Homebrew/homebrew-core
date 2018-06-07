class Xonsh < Formula
  include Language::Python::Virtualenv

  desc "Python-ish, BASHwards-compatible shell language and command prompt"
  homepage "http://xon.sh"
  url "https://github.com/xonsh/xonsh/archive/0.6.6.tar.gz"
  sha256 "48a9f89ee77be6e8da2e5794addcfea4a9df618cf4415bef5a0e97985fa641c8"
  head "https://github.com/xonsh/xonsh.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "ba3a745b40eff1746dcfa409dc17efa7e36cc04f03e9fbefb90bb23f074bd50d" => :high_sierra
    sha256 "7c4525950071bc60c1604748b8d808332002a3ab9e1c794daea6d4b6dbdbbc0e" => :sierra
    sha256 "157fc93347fbbba815ad69afb80e91a82ee57ec53ead8a11be367be25b014785" => :el_capitan
  end

  depends_on "python"

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "4", shell_output("#{bin}/xonsh -c 2+2")
  end
end
