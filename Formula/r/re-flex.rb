class ReFlex < Formula
  desc "Regex-centric, fast and flexible scanner generator for C++"
  homepage "https://www.genivia.com/doc/reflex/html"
  url "https://github.com/Genivia/RE-flex/archive/refs/tags/v5.1.1.tar.gz"
  sha256 "550e371b3b52aad8836b0679ce0f6898f39cf4a6865651aa3f59b2201dd0740c"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1a549e7beaafb45f0f051ae51cfdb3c626c3bc8599989be8f540f987e02e252d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "48bc7c2af29ed5e33a7d64d812acb16d9c3391a87d0d354ddbf0a054eadb6269"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "41d5d3d5a1c78f333c93dc2379c9e89ce1452140b84ac31803fbd3961352c5a7"
    sha256 cellar: :any_skip_relocation, sonoma:        "8b51e6d8f10870bda0075fa3c144019d077e3bf121915dda0187dc6616bf9c4a"
    sha256 cellar: :any_skip_relocation, ventura:       "2be43c844eb1972dfd63ea1cd1573327a025f23f2533f4d901f9305fe1246757"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ee45382b3c6cd2d8617bec5bfc7c82f729ffa540ca3057a4c29c16f6369f1b9a"
  end

  depends_on "pcre2"

  conflicts_with "reflex", because: "both install `reflex` binaries"

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
    system bin/"reflex", "--flex", "echo.l"
    assert_predicate testpath/"lex.yy.cpp", :exist?
  end
end
