class ReFlex < Formula
  desc "Regex-centric, fast and flexible scanner generator for C++"
  homepage "https://www.genivia.com/doc/reflex/html"
  url "https://github.com/Genivia/RE-flex/archive/v3.0.5.tar.gz"
  sha256 "30bfeefc0b977f1bc400f9d3fd98213603e0d8f18d126702b52b7ab2443ef0ef"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "698b879847942af6bcbc8738cf56903e348bdb949bc9109896294f3c203fe4fd"
    sha256 cellar: :any_skip_relocation, big_sur:       "d847556df4ed40b90d737477b2bd232fc4c0a10e921f0233797f16d64d2910f0"
    sha256 cellar: :any_skip_relocation, catalina:      "37aad25eb9e092804c4c324e50a9129f7385938720597b8a2a32c871bf62c05f"
    sha256 cellar: :any_skip_relocation, mojave:        "841fa45f21c5ffac0f93b24ea1f5e2f89673dbf84ecb73ec71544398d0a2f020"
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
