class Repren < Formula
  include Language::Python::Virtualenv

  desc "Rename anything using powerful regex search and replace"
  homepage "https://github.com/jlevy/repren"
  url "https://files.pythonhosted.org/packages/3b/1d/0ec2ddc7a18e40e3dae7ad538d531f85f16c0f8fb798b2e4b19cf0308540/repren-3.1.0.tar.gz"
  sha256 "cb79c0d0e0fdc8f26d445e2828a161aab095067d3a580c71e9c1587b33548ee4"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "c3d39bd2f31358fdabe7862f2089819995a997b245a4d7ba1b7acedb672a36f8"
  end

  depends_on "python@3.14"

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
