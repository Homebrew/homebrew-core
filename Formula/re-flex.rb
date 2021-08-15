class ReFlex < Formula
  desc "Regex-centric, fast and flexible scanner generator for C++"
  homepage "https://www.genivia.com/doc/reflex/html"
  url "https://github.com/Genivia/RE-flex/archive/v3.0.10.tar.gz"
  sha256 "3291f1d39c3ac468ec67d56d4ea6b25b55c987e907c84d1c92cedf19988b0406"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "b84a31ae06ee385552e4e060bba73e8799c365144bef8788cfd5b4342d03f4d9"
    sha256 cellar: :any_skip_relocation, big_sur:       "75ceb641eb144aec09743a7d54b5f0be67530faa8d265c00f404256cdbcb1c27"
    sha256 cellar: :any_skip_relocation, catalina:      "4db30f4b3c4f9f4a9ba699a2d1cdcae61ddfa2d7415b18c667265c250cedff41"
    sha256 cellar: :any_skip_relocation, mojave:        "7255165c7a12f40aa86dcda1f67298ce4f30fd17947e619f846f8b2eee4507ab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "98848d417243524e74af34fe1efc6c3e7774523d9a36dd14943732a867b50a62"
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
