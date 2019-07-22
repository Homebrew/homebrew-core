class Scons < Formula
  desc "Substitute for classic 'make' tool with autoconf/automake functionality"
  homepage "https://www.scons.org/"
  url "https://downloads.sourceforge.net/project/scons/scons/3.1.0/scons-3.1.0.tar.gz"
  sha256 "f3f548d738d4a2179123ecd744271ec413b2d55735ea7625a59b1b59e6cd132f"

  bottle do
    cellar :any_skip_relocation
    sha256 "0f837fb5da5203f5f953be220ab1c3075ff3be6d594d34fcb25f6ebe3d1477f4" => :mojave
    sha256 "0f837fb5da5203f5f953be220ab1c3075ff3be6d594d34fcb25f6ebe3d1477f4" => :high_sierra
    sha256 "4be2ad2f5201a3a59da7047a8fc4919f6e79ae8e1de13f5c5131a8582022ba69" => :sierra
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
