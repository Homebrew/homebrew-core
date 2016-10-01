class Scriptcs < Formula
  desc "Tools to write and execute C#"
  homepage "https://github.com/scriptcs/scriptcs"
  url "https://github.com/scriptcs/scriptcs/archive/v0.16.1.tar.gz"
  sha256 "80d7e5b92a2aa9a2c6fc3409bc7b4793f27ca4bf945413618e01ac96cd8e8827"

  bottle do
    cellar :any_skip_relocation
    sha256 "64c32017fe14dbd9710dc21d74309dba2085583cdd8a9442b067aed72edaffa2" => :sierra
    sha256 "0d37ffc1b70e089876f26fa6682a5d4a90bb4e148f0be4ccc824abca8575546c" => :el_capitan
    sha256 "910ba1adb86a5529cfa18f666b7e2498c1cfb7b73af1497e190ee34301ef5546" => :yosemite
    sha256 "9526293747a6e8c1cd5162390cb3a5d67047b8a7372adad452eafa0c954aea10" => :mavericks
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
