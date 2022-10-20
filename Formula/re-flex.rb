class ReFlex < Formula
  desc "Regex-centric, fast and flexible scanner generator for C++"
  homepage "https://www.genivia.com/doc/reflex/html"
  url "https://github.com/Genivia/RE-flex/archive/v3.2.11.tar.gz"
  sha256 "45b1b7e6bc47f567a16ffec710dcbfd4e95f0f7a34c14472809ca2fcda0ce143"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4e6995acc667bbd6662347d6dd25f81060707127c2a3530fa6e93c73f88d1e73"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e73051f9561c52e462b8c48d49f20b1b9c6d98c8fd366922bc795bde2febeb0e"
    sha256 cellar: :any_skip_relocation, monterey:       "08a85b73eb54e7eaf73bccbe20f3ffd5bae102b1d8d66741952f7d3e55c47d2c"
    sha256 cellar: :any_skip_relocation, big_sur:        "bc9ca40b0a80b4985d08dada025f61ebd58770f93244d0da3681619b746ef9ef"
    sha256 cellar: :any_skip_relocation, catalina:       "3fb6ec9bf8f07558b9db44c47c276fc3ee39e7bfb98e3a028222941b13a2f94f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0bb8ea4a85b761b61e538078f5936726e60dc17243e64b3e2063dd470641aa01"
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
