class ReFlex < Formula
  desc "Regex-centric, fast and flexible scanner generator for C++"
  homepage "https://www.genivia.com/doc/reflex/html"
  url "https://github.com/Genivia/RE-flex/archive/refs/tags/v5.3.0.tar.gz"
  sha256 "f886b2a6354bd5c5e27dce64f5c701a0a8fcb62eafc58d41f8aed9c0582be764"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9904276f2cde33e590880c37a8dd8622ccafd7598cd8395f679254674202a66e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a2b6c5d595dc0acb1f5aaf225755f243d1ff2643b06c345a5ca59808d656c28b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "248e291a3badc7070493a00372bd8ed8cf6973d6473ff58d3075dcf63d537684"
    sha256 cellar: :any_skip_relocation, sonoma:        "f04d2d625190e877e0785a6c572ae4aeff07361d4f8204036bae9c8d782bc329"
    sha256 cellar: :any_skip_relocation, ventura:       "d58041bf4c7aa4e07051611c01e18b52f6ea7df88344cc386d5cc833ba117bd8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e4e27d77c7566c6e8ad7ebb837d382c79b81744186cfcf8f0fc08c7ef8e55656"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fefed57bc699e795663b2e51c9c7abe31dd1c66e239cf4c06dc53843b0d10e81"
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
