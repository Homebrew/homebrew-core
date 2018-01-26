class Saws < Formula
  include Language::Python::Virtualenv

  desc "Supercharged AWS command-line interface (CLI)"
  homepage "https://github.com/donnemartin/saws"
  url "https://github.com/donnemartin/saws/archive/0.4.2.tar.gz"
  sha256 "052b37e73feeea24fb59afcb0bc50119a801533f069535a3dade236517968fe8"
  head "https://github.com/donnemartin/saws.git", :branch => "master"

  # Some AWS APIs require TLS1.2, which system Python doesn't have before High
  # Sierra
  depends_on "python3"

  def install
    venv = virtualenv_create(libexec, "python3")
    system libexec/"bin/pip", "install", "-v", "--no-binary", ":all:",
                              "--ignore-installed", buildpath
    system libexec/"bin/pip", "uninstall", "-y", "saws"
    venv.pip_install_and_link buildpath
  end

  test do
    assert_match "topics", shell_output("#{bin}/saws --help")
  end
end
