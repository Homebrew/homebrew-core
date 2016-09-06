class Scriptcs < Formula
  desc "Tools to write and execute C#"
  homepage "https://github.com/scriptcs/scriptcs"
  url "https://github.com/scriptcs/scriptcs/archive/v0.16.1.tar.gz"
  sha256 "80d7e5b92a2aa9a2c6fc3409bc7b4793f27ca4bf945413618e01ac96cd8e8827"

  bottle do
    cellar :any_skip_relocation
    sha256 "bc27569acd1d41bc9e73a355c89bbf3bbcf8a37bbbb67ae8cf07e49d78927cad" => :el_capitan
    sha256 "73c42a45b854ae25ef1ec2556f5488e2d4b48fecb48b223a7b7a96dfec5c04cf" => :yosemite
    sha256 "096478d971450938f5c2333bc7ce93709c2c3456642477b8bc284093ce610e5a" => :mavericks
  end

  depends_on "mono" => :recommended

  # Upstream commit "Adding brew build script (#1178)"
  # See https://github.com/scriptcs/scriptcs/issues/1172
  # Remove for scriptcs > 0.16.1
  patch do
    url "https://github.com/scriptcs/scriptcs/commit/cff8f5d.patch"
    sha256 "d99e18eee3dd1f545c79155b82c2db23b0315e4124ea54e93060ae284746bba2"
  end

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
