class Scons < Formula
  desc "Substitute for classic 'make' tool with autoconf/automake functionality"
  homepage "https://www.scons.org/"
  url "https://downloads.sourceforge.net/project/scons/scons/3.1.1/scons-3.1.1.tar.gz"
  sha256 "4cea417fdd7499a36f407923d03b4b7000b0f9e8fd7b31b316b9ce7eba9143a5"

  bottle do
    cellar :any_skip_relocation
    sha256 "2b6741458af137560627793b078afdfff7ea18c0ebe95109f040e8e352017464" => :mojave
    sha256 "2b6741458af137560627793b078afdfff7ea18c0ebe95109f040e8e352017464" => :high_sierra
    sha256 "93360d50ab43b502816d1f6c7c930bc52eed3cbb62f58891150441a50606cfa9" => :sierra
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
