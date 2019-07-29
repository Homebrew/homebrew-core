class Scriptcs < Formula
  desc "Tools to write and execute C#"
  homepage "https://github.com/scriptcs/scriptcs"
  url "https://github.com/scriptcs/scriptcs/archive/v0.17.1.tar.gz"
  sha256 "e876118d82f52cbdd9569783ec9278c4ac449055aa628cdcb2d785bf8098a434"

  bottle do
    cellar :any_skip_relocation
    sha256 "121137df4078b2819a16f0f3e75924b10eba51a3ca7ac0a4be3d9010d2d1f7aa" => :mojave
    sha256 "263fda7addb857a9ed3c0c15856c422d3684ad069c2efc644858bb1779a92e91" => :high_sierra
    sha256 "9ccece2f779060ab23e699b07d6cc6ce0b2c2e0058cc995b1541e1170f69a6eb" => :sierra
    sha256 "e3b6cb117d23ccf9a745e0ac5e61fcb531d7e8a08476699d2ece6c31e564450e" => :el_capitan
    sha256 "21891cea519df48979320ba74660002d270fb414181e3f7087505169af15a471" => :yosemite
  end

  depends_on "mono"

  def install
    script_file = "scriptcs.sh"
    system "sh", "./build_brew.sh"
    libexec.install Dir["src/ScriptCs/bin/Release/*"]
    (libexec/script_file).write <<~EOS
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
