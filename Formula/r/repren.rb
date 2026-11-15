class Repren < Formula
  include Language::Python::Virtualenv

  desc "Rename anything using powerful regex search and replace"
  homepage "https://github.com/jlevy/repren"
  url "https://files.pythonhosted.org/packages/8f/2b/74f60c028f4ad0d74b700e508486cf837749c9d1d5a12d56c6086942375e/repren-3.1.1.tar.gz"
  sha256 "f0bf25b08824bc9e34f343aaf6bd1ae8a88b54efb3520de3beb366847e57e98a"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "c03ca2e24b9d9d78324552efa5976f01a8b48a965880e0c5ea7647d7a4bd8bcc"
  end

  depends_on "python@3.15"

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/repren --version")

    (testpath/"test.txt").write <<~EOS
      Hello World!
      Replace Me
    EOS

    system bin/"repren", "--from", "Replace", "--to", "Modify", testpath/"test.txt"
    assert_match "Modify Me", (testpath/"test.txt").read
  end
end
