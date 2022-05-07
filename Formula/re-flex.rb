class ReFlex < Formula
  desc "Regex-centric, fast and flexible scanner generator for C++"
  homepage "https://www.genivia.com/doc/reflex/html"
  url "https://github.com/Genivia/RE-flex/archive/v3.2.6.tar.gz"
  sha256 "844a55f1fc72eda44153296183b7cc45ab26ece89618c3902a19c89e6e3101d1"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9e38733076c50c9516af7e13a5f4670c5989b4d6c78fdc8c2e168cbc2ed8c1c7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cfccb9c7d6e9202c8d9bc9b835985af85a064856d9d176bb54395b62c544d038"
    sha256 cellar: :any_skip_relocation, monterey:       "bba77ecb7c0baf9f4b6e992be123d75c61c5a5b45b82df7806ac42f54d052c7d"
    sha256 cellar: :any_skip_relocation, big_sur:        "b4a3ccc71feb3729fa334d89a2a4143fd6684517ca8b7085c5dc919db841d772"
    sha256 cellar: :any_skip_relocation, catalina:       "1ecadfa539b4fdecb4bcf68b784e5a3e958c9ca568d4ce359f4c5c3caeb45783"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0f1e2bbb667ee7d0579cb224a6c90d3c8b753840373b6846932002106ec6aa85"
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
