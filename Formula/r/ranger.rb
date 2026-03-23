class Ranger < Formula
  include Language::Python::Virtualenv

  desc "File browser"
  homepage "https://ranger.github.io"
  url "https://files.pythonhosted.org/packages/b6/57/c53a45928a3d6ac6a4b3d7a5d54af58a74592d4d405973d249268fc85157/ranger_fm-1.9.4.tar.gz"
  sha256 "bee308b636137b9135111fc795a57cdbb95257f2670101042ac3d7747dec32c8"
  license "GPL-3.0-or-later"
  head "https://github.com/ranger/ranger.git", branch: "master"

  bottle do
    rebuild 3
    sha256 cellar: :any_skip_relocation, all: "cf9392090a9110d00d4c95026536ef2a5988dd9375db3139c20c23f1e79eb74f"
  end

  depends_on "python@3.14"

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ranger --version")

    code = "print('Hello World!')\n"
    (testpath/"test.py").write code
    assert_equal code, shell_output("#{bin}/rifle -w cat test.py")

    ENV.prepend_path "PATH", Formula["python@3.14"].opt_libexec/"bin"
    assert_equal "Hello World!\n", shell_output("#{bin}/rifle -p 2 test.py")
  end
end
