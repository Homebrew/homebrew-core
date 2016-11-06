class Scons < Formula
  desc "Substitute for classic 'make' tool with autoconf/automake functionality"
  homepage "http://www.scons.org"
  url "https://downloads.sourceforge.net/project/scons/scons/2.5.1/scons-2.5.1.tar.gz"
  sha256 "0b25218ae7b46a967db42f2a53721645b3d42874a65f9552ad16ce26d30f51f2"

  bottle do
    cellar :any_skip_relocation
    sha256 "c74c517cbd71ac009888a308226f60a89b55cfa911c667d3e1f773cb5cac2bd1" => :sierra
    sha256 "c74c517cbd71ac009888a308226f60a89b55cfa911c667d3e1f773cb5cac2bd1" => :el_capitan
    sha256 "c74c517cbd71ac009888a308226f60a89b55cfa911c667d3e1f773cb5cac2bd1" => :yosemite
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
    (testpath/"test.c").write <<-EOS.undent
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
