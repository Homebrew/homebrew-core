class Scriptcs < Formula
  desc "Tools to write and execute C#"
  homepage "https://github.com/scriptcs/scriptcs"
  url "https://github.com/scriptcs/scriptcs/archive/v0.17.0.tar.gz"
  sha256 "3ddf5f782d2092b2c1dd8068b2fbd97dca653ca88ade2f3aa4d764e6f2f04318"

  bottle do
    cellar :any_skip_relocation
    sha256 "559d4c5ea83c07a83792aae1886ce3b61d11254f5f94b5529456619439cd7d28" => :sierra
    sha256 "daaf6c6c8bc41f2e70050e1ff58c101ee107419d0f4872e10365517ba204dead" => :el_capitan
    sha256 "1d858aada8a8c6eb7a336a25eb75b4f6a3d49c2474d94388655696aa0941d6e8" => :yosemite
  end

  depends_on "mono" => :recommended

  def install
    script_file = "scriptcs.sh"
    system "sh", "./build_brew.sh"
    libexec.install Dir["src/ScriptCs/bin/Release/*"]
    (libexec/script_file).write <<-EOS.undent
      #!/bin/bash
      mono #{libexec}/scriptcs.exe $@
    EOS
    (libexec/script_file).chmod 0755
    bin.install_symlink libexec/script_file => "scriptcs"
  end

  test do
    test_file = "tests.csx"
    (testpath/test_file).write('Console.WriteLine("{0}, {1}!", "Hello", "world");')
    assert_equal "Hello, world!", `scriptcs #{test_file}`.strip
  end
end
