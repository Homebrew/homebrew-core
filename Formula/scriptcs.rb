class Scriptcs < Formula
  desc "Tools to write and execute C#"
  homepage "https://github.com/scriptcs/scriptcs"
  url "https://github.com/scriptcs/scriptcs/archive/0.16.0.tar.gz"
  sha256 "e51060406606010f1ea67ae2573fcd7bc75b40ebe990ba546c7b646f6b4bdaba"

  bottle do
    cellar :any_skip_relocation
    sha256 "bc27569acd1d41bc9e73a355c89bbf3bbcf8a37bbbb67ae8cf07e49d78927cad" => :el_capitan
    sha256 "73c42a45b854ae25ef1ec2556f5488e2d4b48fecb48b223a7b7a96dfec5c04cf" => :yosemite
    sha256 "096478d971450938f5c2333bc7ce93709c2c3456642477b8bc284093ce610e5a" => :mavericks
  end

  depends_on "mono" => :recommended

  def install
    script_file = "scriptcs.sh"
    system "./build.sh"
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
