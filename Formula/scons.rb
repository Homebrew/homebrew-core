class Scons < Formula
  desc "Substitute for classic 'make' tool with autoconf/automake functionality"
  homepage "http://www.scons.org"
  url "https://downloads.sourceforge.net/project/scons/scons/3.0.0/scons-3.0.0.tar.gz"
  sha256 "0f532f405b98c60b731d231b3c503ab5bf47d89a6f66f70cb62c9249e9f45216"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "7d4495f68be68e5a6756a326914c0b1046921e95cbea330b604319f27bb4fc1f" => :high_sierra
    sha256 "962065c07692369e009d8377f9ee19f2043d07d631093eb7f8aba6f55bccd5bd" => :sierra
    sha256 "962065c07692369e009d8377f9ee19f2043d07d631093eb7f8aba6f55bccd5bd" => :el_capitan
  end

  # Remove for > 3.0.0
  # Upstream commit from 20 Sep 2017 "Support python 2 print statements in SConscripts"
  patch :p2 do
    url "https://github.com/SConsProject/scons/commit/2e0de3c5.patch?full_index=1"
    sha256 "ca9348417478a729f6fdaae62cc25d73a30371c4d467415196246f1d0dcfd195"
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
