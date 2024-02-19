class ReFlex < Formula
  desc "Regex-centric, fast and flexible scanner generator for C++"
  homepage "https://www.genivia.com/doc/reflex/html"
  url "https://github.com/Genivia/RE-flex/archive/refs/tags/v4.0.0.tar.gz"
  sha256 "f11779f3ada5d5f45ace393e1a3fed5aa9d2ccc36afe8b8f91ff636f6460dfa5"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7d092c9be928b592f4a2bfbe148faa395fee91491eb4f019dec4a74a27620bd7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9d7be27ecd0b468be10617699810cac67731fe8361782f6666abb7a3e5bdb128"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "68132abb5ea9fb01e21ea5fd09c14a1b0da03bf6f2440cbc37588f7b1a8e83c9"
    sha256 cellar: :any_skip_relocation, sonoma:         "8a515c196f62c5b405fe827e88c85a7930ccecfe1c53bb4f78b5729ad22bb1d4"
    sha256 cellar: :any_skip_relocation, ventura:        "283aefabd06983a2edc2604e71f426a6088847655dab78194c43474b1d1cafa2"
    sha256 cellar: :any_skip_relocation, monterey:       "e6d91b3a1784a6c56045a7340e612e784a4a90fd7dd3364142df094ca133aa4d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "81b40cff820332ce4159dc07e3dbceaf065614668929cac0847429be5ea46610"
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
