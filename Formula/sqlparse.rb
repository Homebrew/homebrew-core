class Sqlparse < Formula
  include Language::Python::Virtualenv

  desc "Non-validating SQL parser"
  homepage "https://github.com/andialbrecht/sqlparse"
  url "https://files.pythonhosted.org/packages/a2/54/da10f9a0235681179144a5ca02147428f955745e9393f859dec8d0d05b41/sqlparse-0.4.1.tar.gz"
  sha256 "0f91fd2e829c44362cbcfab3e9ae12e22badaa8a29ad5ff599f9ec109f0454e8"
  license "BSD-3-Clause"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "223cb7df4d5a5024e7006b8584edf6c98ab4d7715c1a5e78cc87d9c989d254bb" => :big_sur
    sha256 "23a704c78e708e33de4370e6a8bdff580be8cf707ac0d7708905c0618f6c4d4c" => :arm64_big_sur
    sha256 "474e731b38baa47c6db75bf1ca957e6814148dd166941c70967836eeb3be844e" => :catalina
    sha256 "fe9331f9ef485b2b110cf72fb36a9344d5744efb79b4652b4f8e37c1c43facc6" => :mojave
    sha256 "743a16f18f46d93b073e9dcf01164c1347314fbbbced824d86906a345324e29a" => :high_sierra
  end

  depends_on "python@3.9"

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
