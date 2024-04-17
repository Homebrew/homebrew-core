class ReFlex < Formula
  desc "Regex-centric, fast and flexible scanner generator for C++"
  homepage "https://www.genivia.com/doc/reflex/html"
  url "https://github.com/Genivia/RE-flex/archive/refs/tags/v4.2.1.tar.gz"
  sha256 "98912b68927bf1790a3ff0ba86e62ea20c5be5fe646f18078cca9d7959e03a24"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d6bbde190a392677fe8e851bf3fbc060a6d59345fab881160107fb8e92e0bda0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4a09d184e9bbc22e335bb3bb2037c25c44b048b354731dac543dcbe8293dde7c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "947291bb0fbd3641fcb988a775d873a25527232c94bf550cf3b9098835c00b72"
    sha256 cellar: :any_skip_relocation, sonoma:         "bbdbe72ad57a24a1cfa1fba521d5dce1fc92607b5e416678bd523fd02f55f89f"
    sha256 cellar: :any_skip_relocation, ventura:        "3b8dc22d0c0a98d436aa72eb1b16f85b38a913de36076f7208989eebbb7c0441"
    sha256 cellar: :any_skip_relocation, monterey:       "21a93492f1dd2d0fbb86ddd3f2f434baaf1ebcc84d19351abb31bb8ee1673065"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "83164aacb993780ba19b7712fdd8b4d79809829bb9a55ada6ffc55bef0182ab8"
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
