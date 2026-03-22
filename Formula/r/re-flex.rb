class ReFlex < Formula
  desc "Regex-centric, fast and flexible scanner generator for C++"
  homepage "https://www.genivia.com/doc/reflex/html"
  url "https://github.com/Genivia/RE-flex/archive/refs/tags/v6.1.0.tar.gz"
  sha256 "6a6ca333e45760900734ed40ae9fe4162843d2eca2d3a47923875b1ca89e00a8"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5ac12f3cf19d3d09031811eea4c3b25c32ffa7405418e96523347f482b5873b2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d87444f0f6b45476774bcc95df3e5ca0815e32f0a902f4941d36d9f6e56749da"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0e2b8cd885ac94545cde2f36aa699d7839ce5fc35b2232cbc8f34802daf5d12b"
    sha256 cellar: :any_skip_relocation, sonoma:        "635ffa3ef8bc19e9e713cd363bbaacc26847e69104636c0e8b91ab1120ad341e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4cdadb5513a409c3e86b0b0413f582e628f00a4f23837b08147c6dbf84357e24"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f3818545d3b3a081a4ec934fdc21bedb6a591e5e07e4d26a219ff17852b37983"
  end

  depends_on "pcre2"

  conflicts_with "reflex", because: "both install `reflex` binaries"

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
    system bin/"reflex", "--flex", "echo.l"
    assert_path_exists testpath/"lex.yy.cpp"
  end
end
