class ReFlex < Formula
  desc "Regex-centric, fast and flexible scanner generator for C++"
  homepage "https://www.genivia.com/doc/reflex/html"
  url "https://github.com/Genivia/RE-flex/archive/refs/tags/v4.4.0.tar.gz"
  sha256 "3b34d0c88f91db6b5387355a64a84bfa6464d90fb182aab05c367605db28d2e8"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ada26cc2c9d1e3267fd3d21b94b394da2862f92064d846afd5122db1218e9ccd"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5c3411840dcfd31e2a1700452febcf6fa0d02e158f33dcde9b025eb9d5ccd8c9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5c7112929045538e68e033035b5cd82a14a7f0028cec7109830b25047f48628e"
    sha256 cellar: :any_skip_relocation, sonoma:         "3108751ef05e85bbc4af0d7ea38f5dd29a3b7c796fe7376d97e7c979785818ae"
    sha256 cellar: :any_skip_relocation, ventura:        "9abda42f161087d4c015b3bf8867e93fb071550b57c8f2afd88764aba05f7faa"
    sha256 cellar: :any_skip_relocation, monterey:       "713ad02e5f29c08d5c2b04d66dd1232c402cbe4a286a5e5b3964e58539f2f5c4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f17aaa049cdccb0663471ce45f6a54ab4de6cfeb643046aa0fdc1976a1f9564c"
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
