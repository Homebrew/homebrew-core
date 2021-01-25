class ReFlex < Formula
  desc "Regex-centric, fast and flexible scanner generator for C++"
  homepage "https://www.genivia.com/doc/reflex/html"
  url "https://github.com/Genivia/RE-flex/archive/v3.0.1.tar.gz"
  sha256 "7ceab8075677e618b39451ff5487a7f463f8e1bfa7668010ae992d84eefd6dca"
  license "BSD-3-Clause"

  bottle do
    cellar :any_skip_relocation
    sha256 "b81ec2d7ce47750d4e1c7c9f3ef6f1dfb6725b64c15dc91b7a795116088c5ddc" => :big_sur
    sha256 "dae04f5572e5ef2e6cc5c55adc1b33793f03c3ab6c2cf9bcc66b23907af8d969" => :arm64_big_sur
    sha256 "7e662642c4a570ffabfc137b9c5259b687bd438deaf0da4909ab18f4c877c69b" => :catalina
    sha256 "21297a3a6515110965ace284f6055015439677f6edf811f2803560318f8d286f" => :mojave
  end

  depends_on "pcre2"

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
