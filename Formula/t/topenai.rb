class Topenai < Formula
  include Language::Python::Virtualenv

  desc "Simple CLI tool to interact with OpenAI"
  homepage "https://github.com/vladzima/topenai"
  url "https://files.pythonhosted.org/packages/ea/f8/febbfac6ca11c49c3f3180ec39ca00e8b50dfaba368710ddf70d1353c404/topenai-0.0.8.tar.gz"
  sha256 "d0d5fca85d18da2385c9a30454bf112f7b18d92e4d87c2a8c5b3a153065cf52f"

  depends_on "python@3.11"

  resource "requests" do
    url "https://files.pythonhosted.org/packages/9d/be/10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3/requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/8b/e1/43beb3d38dba6cb420cefa297822eac205a277ab43e5ba5d5c46faf96438/idna-3.4.tar.gz"
    sha256 "814f528e8dead7d329833b91c5faa87d60bf71824cd12a7530b5526063d02cb4"
  end

  def install
    virtualenv_create(libexec, "python3")
    virtualenv_install_with_resources
  end

  test do
    assert_match "test-ok", shell_output("#{bin}/topenai -test")
  end
end
