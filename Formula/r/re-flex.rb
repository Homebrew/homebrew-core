class ReFlex < Formula
  desc "Regex-centric, fast and flexible scanner generator for C++"
  homepage "https://www.genivia.com/doc/reflex/html"
  url "https://github.com/Genivia/RE-flex/archive/refs/tags/v4.1.2.tar.gz"
  sha256 "f9da531b00823c0fd245a67e5c27593b6a3dbe23827a02266c03f6fba94d503a"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6354aef63d355b8ed8bf51c4f5ff31d0dcdf11fb32fcbc690e8b428166313863"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "19d09d7a408a9d946609c1d9cf044f4a43de94cd2895fbcdd57b0473177c58c5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "111fd60d84ff257b3339db6ca85425b8edd934a08f31376e851b8f05e7e03730"
    sha256 cellar: :any_skip_relocation, sonoma:         "4a0cb5d151bea3cd31b7436d6c943a2d0ff7f94dbe5a2f0637c573e344ecec0e"
    sha256 cellar: :any_skip_relocation, ventura:        "715bfe741d52b83bd4639c5a55920c40e960dc2fdab21fc80e7036ef12496ba9"
    sha256 cellar: :any_skip_relocation, monterey:       "5e1fe659816f079ec905e4828a3f774456ffb9dfa4b727dcdbb18a661a6db56e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "236d90cfb17123af30fae6482025e786a5c169265a6630d7ce40f4a5bd0729f8"
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
