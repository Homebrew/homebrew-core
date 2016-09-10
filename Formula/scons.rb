class Scons < Formula
  desc "Substitute for classic 'make' tool with autoconf/automake functionality"
  homepage "http://www.scons.org"
  url "https://downloads.sourceforge.net/project/scons/scons/2.5.0/scons-2.5.0.tar.gz"
  sha256 "eb296b47f23c20aec7d87d35cfa386d3508e01d1caa3040ea6f5bbab2292ace9"

  bottle do
    cellar :any_skip_relocation
    sha256 "9533460b2c2b8cb5598a3d49e6c2dbab5713424ffdcc51404eefa2454cecaa0b" => :sierra
    sha256 "40ab513e26ac5d381fcb23aa29204287aaa10e85ef52d2d1b50a9b0a982188a7" => :el_capitan
    sha256 "a78c3467e61f01fa46f67df30a99f9be388fcf3acf86963536dd6c3a86933d13" => :yosemite
    sha256 "c4caaecddb77700ebc2738ecd424c9352415c21f2621bb815632b98a0dc16dea" => :mavericks
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
