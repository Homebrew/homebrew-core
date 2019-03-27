class ReFlex < Formula
  desc "The regex-centric, fast and flexible scanner generator for C++"
  homepage "https://www.genivia.com/doc/reflex/html"
  url "https://github.com/Genivia/RE-flex/archive/v1.1.3.tar.gz"
  sha256 "f46b87db2c39cee8f36282a69b3b63559189bc84c8af5f893ef381b575ed35cd"

  bottle do
    cellar :any_skip_relocation
    sha256 "31b0293a7ac19c77d00f7441fa3b7bb69013bed19328bb163b7c34d365290007" => :mojave
    sha256 "8bc106f9b3a10fcafce9390a4d9f3a811c95222e1188ff98af344ee1ea14bc60" => :high_sierra
    sha256 "b41459674440a7941774ae3752a232bdef0d8819eddec21c2a5e073c683ec4ee" => :sierra
  end

  depends_on "boost"

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
