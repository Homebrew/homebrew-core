class ReFlex < Formula
  desc "Regex-centric, fast and flexible scanner generator for C++"
  homepage "https://www.genivia.com/doc/reflex/html"
  url "https://github.com/Genivia/RE-flex/archive/v3.5.0.tar.gz"
  sha256 "24a51144b640a1f38fb2229ef1d234d56c302a6af6facf0cd396a815fdb8e461"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2ce022ba21e4330a9a11073c8fee0a480ca19f57e16b6146642d357b0f9adb33"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a583cada07c904218fe2bec6c1f71c76cd7282efb1ad9d3df2d79ca79c914065"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "295f843c82fa882e8ce752d7f0988cc3ac29f70ecf94acbf97dbe68759ed4ae8"
    sha256 cellar: :any_skip_relocation, sonoma:         "5b64c5e7b5dd9253ee23f0dc7c79933d1ede29f4a35f6fe4ab2a74403e9afe70"
    sha256 cellar: :any_skip_relocation, ventura:        "8931c85b54160355e89b908330710b38bda1ed9613c27d26de1496accddde96b"
    sha256 cellar: :any_skip_relocation, monterey:       "0f515630d36d1f18065b8d47f530125a91c7991130a9a27fbfdb9b24437e3f0c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "429b859e8e80433cac047e9202c439b88c232117b3d73342a463beb3ba99a876"
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
