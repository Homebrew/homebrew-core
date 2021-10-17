class ReFlex < Formula
  desc "Regex-centric, fast and flexible scanner generator for C++"
  homepage "https://www.genivia.com/doc/reflex/html"
  url "https://github.com/Genivia/RE-flex/archive/v3.0.12.tar.gz"
  sha256 "3341ac841a79544e7645027ab9e920a76971cdb85d1d12b0b67275614418d916"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "3496ab037320dde290d28351caad2e7e810ddd60910eb5198b16d646a2a4e428"
    sha256 cellar: :any_skip_relocation, big_sur:       "3fe7162edbdd072be4f74d61f2cbde1b034bdcaed8c879e23c8b1b5f2e917599"
    sha256 cellar: :any_skip_relocation, catalina:      "9a6da54b6cf93f967e84230fa45b1c917d2d75389073748f524fb70aaef1ff95"
    sha256 cellar: :any_skip_relocation, mojave:        "1f28c3a74833bc14642071d74c7d441fb93bfa516a4edf0282dc6cf373b70c6d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d95a8b2459e89cc29400263958eae3b3f4d02f506d5c0cc5afa37fa04874222a"
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
