class ReFlex < Formula
  desc "Regex-centric, fast and flexible scanner generator for C++"
  homepage "https://www.genivia.com/doc/reflex/html"
  url "https://github.com/Genivia/RE-flex/archive/v3.3.0.tar.gz"
  sha256 "debe8997c71b5f487daf9f7548b8094b87a6ece24eed9aa7dda3dc6fe7b68328"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "438633c8b659d98754fbea408e798cca0cddd3dd5e39bedd32eb328d161da18f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "77837fe3ce37448ec5e1e4eed4b561e85eac01013c96b5065d55ac0442fd0b49"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b66772baf8a52bbf1c2977524c3dbdc87aede10e973bde8ac5148820856806c6"
    sha256 cellar: :any_skip_relocation, ventura:        "9dd782c7ed2613d95427448c238670264fc9f82a82562992600a62835da1dfab"
    sha256 cellar: :any_skip_relocation, monterey:       "40f4e442d633c27cfa8d69102549af6cc4bde0417c45c97881bc02c61dff37a7"
    sha256 cellar: :any_skip_relocation, big_sur:        "2dd06d4c6e89a49f8fb1b5f353184aea5e74ce24c95bc894230e118a5aeb52b9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eaa57224032658027c73e4a3d19964877f1fa7f56a401588608fa9725a77aae4"
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
