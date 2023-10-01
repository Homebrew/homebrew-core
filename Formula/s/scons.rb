class Scons < Formula
  include Language::Python::Virtualenv

  desc "Substitute for classic 'make' tool with autoconf/automake functionality"
  homepage "https://www.scons.org/"
  url "https://files.pythonhosted.org/packages/e6/a4/c7a1fb8e60067fe4eb5f4bfd13ce9f51bec963dd9a5c50321d8a20b7a3f2/SCons-4.5.2.tar.gz"
  sha256 "813360b2bce476bc9cc12a0f3a22d46ce520796b352557202cb07d3e402f5458"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b67972a2eab837b567c354e5d2a1ae4b24317fee04fcca4a82220bfc505f9e24"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3cfcfdd83e5edbd3b8ed90976269278737c1a3e9efb6d3cb5d6a380620ee3713"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "64f3933ba80d887230f25d5137136eecc27160c9ba067af4c1ac2f2b94f63c44"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "817c9d010d9a6046f62d078cfcda4ddbb8b53966bb31b7379d14015fa06c32be"
    sha256 cellar: :any_skip_relocation, sonoma:         "7f074a744581f96206c1205c4b69ed6454b5a42ad383ab1e1984a89a585ab7f0"
    sha256 cellar: :any_skip_relocation, ventura:        "3896a807bcd09245ed26eab9f92f0600a6c686902cb5c03ef71bf9683919ec68"
    sha256 cellar: :any_skip_relocation, monterey:       "6f8bf08a284bc8b210ed3b6bc83ff588898ddc2fa8057c5c178e3986961bee30"
    sha256 cellar: :any_skip_relocation, big_sur:        "47ed8b6d98fcc32e2e7cbea6e1c56941768b343a2df2adbf3fbb9947dbdab6ad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b3c12f417a71fb64a12b39ff8ba5c179550594c587bb75c936bfd2da9ea858cb"
  end

  depends_on "python@3.11"

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      int main()
      {
        printf("Homebrew");
        return 0;
      }
    EOS
    (testpath/"SConstruct").write "Program('test.c')"
    system bin/"scons"
    assert_equal "Homebrew", shell_output("#{testpath}/test")
  end
end
