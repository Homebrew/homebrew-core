class ReFlex < Formula
  desc "The regex-centric, fast and flexible scanner generator for C++"
  homepage "https://www.genivia.com/doc/reflex/html"
  url "https://github.com/Genivia/RE-flex/archive/v1.4.3.tar.gz"
  sha256 "8cb9cc9bf40ecc145955fa52570312821bc924d6dba1021ab23af95755c04c3a"

  bottle do
    cellar :any_skip_relocation
    sha256 "e3f2cd5f69be4af53feb59e2c0efc7cf7598c6b93d56c6216e708f0f62c54a32" => :mojave
    sha256 "d53f164e8f40b7a7d4061f5b2475998e646279bfc4923072ce54a0c20e177aca" => :high_sierra
    sha256 "38c75cab013126d8f8228de013eab035e1ebcc38a682cac846ddbc686103a8b9" => :sierra
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
