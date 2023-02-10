class ReFlex < Formula
  desc "Regex-centric, fast and flexible scanner generator for C++"
  homepage "https://www.genivia.com/doc/reflex/html"
  url "https://github.com/Genivia/RE-flex/archive/v3.3.0.tar.gz"
  sha256 "debe8997c71b5f487daf9f7548b8094b87a6ece24eed9aa7dda3dc6fe7b68328"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "503f18b32d1b3abcffc4007c843e0ef37361387b209f3a2bc477bb7d3f553b2a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bc5306b00f6e0c9fe6b20d3760a035d82b73a9fa476f695389127905e337eb3f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "35a766a8eecf5679e8174e1a05db57c8002b4e284f26ac9e8185b66f866dfb7e"
    sha256 cellar: :any_skip_relocation, ventura:        "72f3121697822b40d45bf686db52e0ffea0e34b0ca72fb0901ec75043bba6368"
    sha256 cellar: :any_skip_relocation, monterey:       "746830bf238437e5c0bf9c39623cfb5b74be986200980f0db5442ffae0302212"
    sha256 cellar: :any_skip_relocation, big_sur:        "f9707741c2d8c561aabcacd604856c0a51962ed09e71ae9eac2a7dca049f3746"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d192b45805cb089af4c4dcd449bbb2d75d8026672221a9aca1fea6c702404db9"
  end

  depends_on "pcre2"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"echo.l").write <<~EOS
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
