class ReFlex < Formula
  desc "Regex-centric, fast and flexible scanner generator for C++"
  homepage "https://www.genivia.com/doc/reflex/html"
  url "https://github.com/Genivia/RE-flex/archive/v3.3.4.tar.gz"
  sha256 "faad674769291812b0a9949fbf95f1ad22a273121b48aefc30c20ea0d4c2585b"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "62d25e4835fdf20b20f6bdca577d38bb25f8d5a00387e09253d4aecc1498cf76"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "883f68f10e5427bcc7103e40acc580f56acbb888a65caaae341e68a41a30ba33"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d541135929dccdb8ee6e919aba91427298f32a55812246c97faeff1a998c8ba5"
    sha256 cellar: :any_skip_relocation, ventura:        "71415b23b257f273b12f59404e6188ebc0ee104a33ba8c1d30c7b196d9ea4b39"
    sha256 cellar: :any_skip_relocation, monterey:       "9087017b64f6ec2a23fd46f8a15a3581060b3912d3ee78cd0d682dee628c7eba"
    sha256 cellar: :any_skip_relocation, big_sur:        "afd4849ecc4c9790e6862201c8387f4538e3d882a96f5eb2ee23239a4529b94a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b68262f0b00e4f81e7c772f50c868cd1428b57ffcb44008e753a546031c4101e"
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
