class ReFlex < Formula
  desc "Regex-centric, fast and flexible scanner generator for C++"
  homepage "https://www.genivia.com/doc/reflex/html"
  url "https://github.com/Genivia/RE-flex/archive/refs/tags/v4.1.2.tar.gz"
  sha256 "f9da531b00823c0fd245a67e5c27593b6a3dbe23827a02266c03f6fba94d503a"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5799dd4323146b3f0a70f1614c2b0dccf9b904c482fc6c44cb8f165f02dc0585"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b42aa699412511e87f4650dac31bfdc96bca5e9d55e06601bd0ef484c3e81d27"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ee1725a63d5620ae1bd940e34067a8b5f2ed8dea22eb4b96c0e76231f1146533"
    sha256 cellar: :any_skip_relocation, sonoma:         "96276a42eafe04a411c9d83bbc287d04019ec67a4bfdf842120f9f261225840b"
    sha256 cellar: :any_skip_relocation, ventura:        "e36c11156d5230611235591f03c836d31622cf12c4c49ae1d00d998d0299204e"
    sha256 cellar: :any_skip_relocation, monterey:       "f14bbf3ea6199ad0f316c6ccdbacab210a74347897e5201bdf347f919b91f516"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "86dfc822b8345520cef598eab63e3f5d338fd6c6de29c08c9b28de7da2af19ed"
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
