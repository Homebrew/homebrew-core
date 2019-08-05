class ReFlex < Formula
  desc "The regex-centric, fast and flexible scanner generator for C++"
  homepage "https://www.genivia.com/doc/reflex/html"
  url "https://github.com/Genivia/RE-flex/archive/v1.3.2.tar.gz"
  sha256 "aaad0c9b7c7907567c3ccf4fd0abcc9a8e5f8d1caa653557c36997443ce3189f"

  bottle do
    cellar :any_skip_relocation
    sha256 "b0b9b8b9e8e6261e8a5838b886bba73a160ec1644d0a708ed2d656295145b9ac" => :mojave
    sha256 "70006a21a1d1f2192be7792a251a49669bd805235641b1c20e7ef16556b227a9" => :high_sierra
    sha256 "eccc6b41c77c6951b489df54456cfef3c52f50efab0213820e8e8e8637d3bd5e" => :sierra
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
