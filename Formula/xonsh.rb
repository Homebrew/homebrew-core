class Xonsh < Formula
  desc "Python-ish, BASHwards-compatible shell language and command prompt"
  homepage "http://xon.sh"
  url "https://github.com/scopatz/xonsh/archive/0.3.3.tar.gz"
  sha256 "c660151a872e13c6596812200c0e7cf6e0b2cfd0ac01a4f8106b14918c959ce9"
  head "https://github.com/scopatz/xonsh.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "3fe6c3bd8ec310d758eb36c821f90ad752a48126cd21ad0aea2e8e7af92d6765" => :el_capitan
    sha256 "20bc5239a19517ad3a645723e7e16e7ae06c9aa508a2f7cb9e0858c388bc751b" => :yosemite
    sha256 "df777eced112be997ae656ef4050181680a4a1b8b715203b50301ce59efea906" => :mavericks
  end

  depends_on :python3

  resource "ply" do
    url "https://pypi.python.org/packages/96/e0/430fcdb6b3ef1ae534d231397bee7e9304be14a47a267e82ebcb3323d0b5/ply-3.8.tar.gz"
    sha256 "e7d1bdff026beb159c9942f7a17e102c375638d9478a7ecd4cc0c76afd8de0b8"
  end

  def install
    version = Language::Python.major_minor_version "python3"
    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python#{version}/site-packages"
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python#{version}/site-packages"

    resource("ply").stage do
      system "python3", *Language::Python.setup_install_args(libexec/"vendor")
    end

    system "python3", *Language::Python.setup_install_args(libexec)
    bin.install Dir[libexec/"bin/*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    assert_match "4", shell_output("#{bin}/xonsh -c 2+2")
  end
end
