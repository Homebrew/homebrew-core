class Xonsh < Formula
  include Language::Python::Virtualenv

  desc "Python-ish, BASHwards-compatible shell language and command prompt"
  homepage "http://xon.sh"
  url "https://github.com/xonsh/xonsh/archive/0.6.7.tar.gz"
  sha256 "1ff04ac5aa8a9cfc6d88303bcf9ee304721be27e77ce14978804d9b52f3a1d3c"
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
