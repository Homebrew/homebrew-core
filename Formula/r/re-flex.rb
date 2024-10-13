class ReFlex < Formula
  desc "Regex-centric, fast and flexible scanner generator for C++"
  homepage "https://www.genivia.com/doc/reflex/html"
  url "https://github.com/Genivia/RE-flex/archive/refs/tags/v4.5.0.tar.gz"
  sha256 "30a503087c4ea7c2f81ef8b7f1c54ea10c3f26ab3a372d2c874273ee5e643472"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "2fae21f8f63d77f266cb35b47e719c0af4eb19d71eb44f5b3ca45c69b8954414"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d56dec266434d969c9f98a11e6e26de3288e02fd78d5f6dfd629a132406c1266"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ae8afca45f469217a31f70145b8cd1938c44e0cd5b9d47ca7a6d9ae61ad35d43"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "491b3a0dd92ddfac41d0cb8d8d5578e48c1ea22512a45b8fcb112f09acdabbaf"
    sha256 cellar: :any_skip_relocation, sonoma:         "3e86003d5d03505c2cce6129a2d559f862aa081d9ce067f58562d67744998410"
    sha256 cellar: :any_skip_relocation, ventura:        "3b907cd92a022c89cae7bf173dcf27537e25013d354b31ca029dc2e3554e3578"
    sha256 cellar: :any_skip_relocation, monterey:       "3d23b20c585db8a7b136c5a13f3826784fbaf5a78bcc74752b5358761b0d7ebf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "84833f688d2b9ddd9b59723d17aca1b21069f46493d6837fa053f3eb95198717"
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
    assert_predicate testpath/"lex.yy.cpp", :exist?
  end
end
