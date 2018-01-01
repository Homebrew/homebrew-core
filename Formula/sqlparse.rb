class Sqlparse < Formula
  include Language::Python::Virtualenv

  desc "Non-validating SQL parser"
  homepage "https://github.com/andialbrecht/sqlparse"
  url "https://files.pythonhosted.org/packages/79/3c/2ad76ba49f9e3d88d2b58e135b7821d93741856d1fe49970171f73529303/sqlparse-0.2.4.tar.gz"
  sha256 "ce028444cfab83be538752a2ffdb56bc417b7784ff35bb9a3062413717807dec"

  bottle do
    cellar :any_skip_relocation
    sha256 "e4ec0cc5f8d0b388deee1a472d90dc3007f97ea34f5850e103b72fd3861242fa" => :high_sierra
    sha256 "81b99b0f9d66e749b781faaf3beabf199a9381ada9723bb2ef1ebb1b80240154" => :sierra
    sha256 "7155f5eca1b0f127a1f82846842c50e540460093ebc0b6735b724979594b6a06" => :el_capitan
  end

  depends_on "python" if MacOS.version <= :snow_leopard

  def install
    virtualenv_install_with_resources
  end

  test do
    expected = <<~EOS.chomp
      select *
        from foo
    EOS
    output = pipe_output("#{bin}/sqlformat - -a", "select * from foo", 0)
    assert_equal expected, output
  end
end
