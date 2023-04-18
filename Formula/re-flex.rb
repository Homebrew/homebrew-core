class ReFlex < Formula
  desc "Regex-centric, fast and flexible scanner generator for C++"
  homepage "https://www.genivia.com/doc/reflex/html"
  url "https://github.com/Genivia/RE-flex/archive/v3.3.2.tar.gz"
  sha256 "1e927c84d55014e1b4dac3208cc9e3f445f3d466c72fc2889c012f524434fe11"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6eb5e1c0f846d4324584f2d86e587889792250ec1ba4a1a88a23b86c7a4890f2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8ea99e1608fe942fa5565ea9b73bfb7ffee1a8465322acc3552aa693938b6b5e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3e44fe4e349ac3c63bebccf6e8e31d2521dab423eb4f1c2bb138cf1c088a43f7"
    sha256 cellar: :any_skip_relocation, ventura:        "7af75c3ec09e0af8cf79720c789210557674a10767858a1429ec9064e14a0a0f"
    sha256 cellar: :any_skip_relocation, monterey:       "9e114c674306de720f6398792ceb563918ff7b89e384e8ebb024f2a933ddc495"
    sha256 cellar: :any_skip_relocation, big_sur:        "97d5ea7100cff54f6dff15a5d19df50af3ef0f25e792611b5c3df11bd8927b19"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5df43ef88c298036e12f1959e8241d6928a4b07d9a1a80b9b13fb825b3877926"
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
