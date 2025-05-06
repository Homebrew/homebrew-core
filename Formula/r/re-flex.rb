class ReFlex < Formula
  desc "Regex-centric, fast and flexible scanner generator for C++"
  homepage "https://www.genivia.com/doc/reflex/html"
  url "https://github.com/Genivia/RE-flex/archive/refs/tags/v5.4.0.tar.gz"
  sha256 "729b214ecb0eb437c6562120b8f0fa294505684fc6eebac552fe8e335987dc60"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4afb75c344af21a1d8dc9092ae9d2ee425ad0ff728252ef1c5fd8a57d1ff3190"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b46b945ff905b369bb2177cba976ef601995de9fca17d3ebdcfa2308dd111993"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2c4cfdbb722bae3beb2ba5113e8ee57204103a0bdee9fae2505b423205018378"
    sha256 cellar: :any_skip_relocation, sonoma:        "17add8f83b7b7a406aa0521ba7eda56613af1e5d19f23513efd38412f10a9088"
    sha256 cellar: :any_skip_relocation, ventura:       "9cbaecc825513c77a7d6ade47928207abfad56ede112453a906d20e70cc969c7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cd3663f209e2957999a8e5d9bc73a87e8e341ebd9310d06b2e6a11b093b03f50"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "811efbc1e7a8fcf03d5ab690647ef7fdd81131238fa9dd393b002af5caca21c9"
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
