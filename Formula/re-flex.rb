class ReFlex < Formula
  desc "The regex-centric, fast and flexible scanner generator for C++"
  homepage "https://www.genivia.com/doc/reflex/html"
  url "https://github.com/Genivia/RE-flex/archive/v1.4.3.tar.gz"
  sha256 "8cb9cc9bf40ecc145955fa52570312821bc924d6dba1021ab23af95755c04c3a"

  bottle do
    cellar :any_skip_relocation
    sha256 "075657453a8dc116d425965a5ad8432b3b66b8b9cfd581eabdcaa0c595e5ebf1" => :catalina
    sha256 "caf15bf38d93db054e1f90a9182802b7df688b3266dccd48ccd7550c7d7d50e7" => :mojave
    sha256 "aeee136f831845272ba2e5b67aee5cbe6e93a6d4b77a9991f5bd0bda88f93e76" => :high_sierra
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"echo.l").write <<~'EOS'
      %{
      #include <stdio.h>
      %}
      %option noyywrap main
      %%
      .+  ECHO;
      %%
    EOS
    system "#{bin}/reflex", "--flex", "echo.l"
    assert_predicate testpath/"lex.yy.cpp", :exist?
  end
end
