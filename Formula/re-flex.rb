class ReFlex < Formula
  desc "Regex-centric, fast and flexible scanner generator for C++"
  homepage "https://www.genivia.com/doc/reflex/html"
  url "https://github.com/Genivia/RE-flex/archive/v3.2.3.tar.gz"
  sha256 "6aa5c054026dd031615638103e89c303f94af3d69f2250de25c4b81c34bafa07"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3d2e724ffc15127696496b1c19ed77297b1a846454b49ef5ade5de3d2a4e5927"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9cc01aaaa3672db0fdd5e106ad91aa762e91846f54f0011605b6db73dd79c420"
    sha256 cellar: :any_skip_relocation, monterey:       "b9bba0f658b1720ae75a4453ae17fa251ffff71501b2adc5b6ff990d1bb3d676"
    sha256 cellar: :any_skip_relocation, big_sur:        "fbbb10cc55cc90f77e8607626330dc7116f9e41c803adb9c7af432700c9c0201"
    sha256 cellar: :any_skip_relocation, catalina:       "3e8387e513e77c4240f4eb848a23fa8ab66f94a557f5ef182d70c1241dc93730"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a18af6e712e7a718ecade84f1c60da9e4cebac298e14260d6b9c2ab4b1992384"
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
