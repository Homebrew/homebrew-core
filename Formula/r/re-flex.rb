class ReFlex < Formula
  desc "Regex-centric, fast and flexible scanner generator for C++"
  homepage "https://www.genivia.com/doc/reflex/html"
  url "https://github.com/Genivia/RE-flex/archive/refs/tags/v4.2.0.tar.gz"
  sha256 "deb0fbfe89fb3f47c5934138537ab9ac4cb31d3c952ce7e8243d79f2067c5dd1"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8a7de5079585843c32006586ae24f6e0672a3bfe028a96d4553c541f6cfa0da7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1473ff1ecc41500c0835a061c3ba48a08b4dfade3da0e8ac8539ac5a352bfb85"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "426772211dfc03bb003e5f1b01493b32054f24531a945a70695750d5f5d373c5"
    sha256 cellar: :any_skip_relocation, sonoma:         "48739d3fb8180455d2bd0aec50cb7cbf213b621c775673795aa1d04e272f3db4"
    sha256 cellar: :any_skip_relocation, ventura:        "eb42a6d24c108af785582ee2ded7f6f1bb3ba43c2940468ce414efb0c75ff426"
    sha256 cellar: :any_skip_relocation, monterey:       "d49b2e0edfba3f3963a49835635e7fafc7d1a844d689e77a936c4fd05ea67d5d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ed30398c010f639291b7495862afe384471bea31fcc5b285c7e8957902c888b3"
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
