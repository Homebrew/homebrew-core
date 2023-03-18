class ReFlex < Formula
  desc "Regex-centric, fast and flexible scanner generator for C++"
  homepage "https://www.genivia.com/doc/reflex/html"
  url "https://github.com/Genivia/RE-flex/archive/v3.3.2.tar.gz"
  sha256 "1e927c84d55014e1b4dac3208cc9e3f445f3d466c72fc2889c012f524434fe11"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1ebd2fc5208dc74482024450bd3d51a34a62debec4d09a488865923f4e021634"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "73949617e2a7b49ddeef20755bfd289572f024a49dd5707f8393c55cae035a43"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c040bec4d6cea8a8dc8de7af6b447142c4600293b9d165ec0734d7105bce1993"
    sha256 cellar: :any_skip_relocation, ventura:        "745fe573780b821ee4799a7972a0bb3a788ccd1221cb016959367ef334249e62"
    sha256 cellar: :any_skip_relocation, monterey:       "8f317da381d77b26719efce4c6d2a19d355b6bcbc2229de91ba5565b653f5ce5"
    sha256 cellar: :any_skip_relocation, big_sur:        "97bea016094a7fb84113ec75d02887cb17d8f107130bf5bc9baf4a071d7a319e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1c3e579f0fd5a8d6760a4e345fba9644277f639c119ac9975ab2c9ccd4e2702b"
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
