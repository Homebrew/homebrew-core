class Scons < Formula
  desc "Substitute for classic 'make' tool with autoconf/automake functionality"
  homepage "https://www.scons.org/"
  url "https://downloads.sourceforge.net/project/scons/scons/3.0.2/scons-3.0.2.tar.gz"
  sha256 "d0afcf8f4c2ea5fa7af3c9321c0cb3ea1c83d137196be10c4cb2c79cc5dade01"

  bottle do
    cellar :any_skip_relocation
    sha256 "169ca2e43315449b82c660d78c9586a0662c59ea069b09bdf7f941f6a4afff9f" => :mojave
    sha256 "c791b4905477a5fbc33345cef5e412807ffc90ba6ea35bfc9a263f542702aa1c" => :high_sierra
    sha256 "c791b4905477a5fbc33345cef5e412807ffc90ba6ea35bfc9a263f542702aa1c" => :sierra
    sha256 "c791b4905477a5fbc33345cef5e412807ffc90ba6ea35bfc9a263f542702aa1c" => :el_capitan
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
