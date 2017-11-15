class Scons < Formula
  desc "Substitute for classic 'make' tool with autoconf/automake functionality"
  homepage "http://www.scons.org"
  url "https://downloads.sourceforge.net/project/scons/scons/3.0.1/scons-3.0.1.tar.gz"
  sha256 "24475e38d39c19683bc88054524df018fe6949d70fbd4c69e298d39a0269f173"

  bottle do
    cellar :any_skip_relocation
    sha256 "45b5033015138593fb5b2a6dfa4d74b1db3feff8c6a6e49a8a510682af6bcd3f" => :high_sierra
    sha256 "45b5033015138593fb5b2a6dfa4d74b1db3feff8c6a6e49a8a510682af6bcd3f" => :sierra
    sha256 "45b5033015138593fb5b2a6dfa4d74b1db3feff8c6a6e49a8a510682af6bcd3f" => :el_capitan
  end

  def install
    man1.install gzip("scons-time.1", "scons.1", "sconsign.1")
    system "/usr/bin/python", "setup.py", "install",
             "--prefix=#{prefix}",
             "--standalone-lib",
             # SCons gets handsy with sys.path---`scons-local` is one place it
             # will look when all is said and done.
             "--install-lib=#{libexec}/scons-local",
             "--install-scripts=#{bin}",
             "--install-data=#{libexec}",
             "--no-version-script", "--no-install-man"

    # Re-root scripts to libexec so they can import SCons and symlink back into
    # bin. Similar tactics are used in the duplicity formula.
    bin.children.each do |p|
      mv p, "#{libexec}/#{p.basename}.py"
      bin.install_symlink "#{libexec}/#{p.basename}.py" => p.basename
    end
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
