class Scriptcs < Formula
  desc "Tools to write and execute C#"
  homepage "https://github.com/scriptcs/scriptcs"
  url "https://github.com/scriptcs/scriptcs/archive/v0.17.0.tar.gz"
  sha256 "3ddf5f782d2092b2c1dd8068b2fbd97dca653ca88ade2f3aa4d764e6f2f04318"

  bottle do
    cellar :any_skip_relocation
    sha256 "64c32017fe14dbd9710dc21d74309dba2085583cdd8a9442b067aed72edaffa2" => :sierra
    sha256 "0d37ffc1b70e089876f26fa6682a5d4a90bb4e148f0be4ccc824abca8575546c" => :el_capitan
    sha256 "910ba1adb86a5529cfa18f666b7e2498c1cfb7b73af1497e190ee34301ef5546" => :yosemite
    sha256 "9526293747a6e8c1cd5162390cb3a5d67047b8a7372adad452eafa0c954aea10" => :mavericks
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
