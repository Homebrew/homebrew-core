class ReFlex < Formula
  desc "Regex-centric, fast and flexible scanner generator for C++"
  homepage "https://www.genivia.com/doc/reflex/html"
  url "https://github.com/Genivia/RE-flex/archive/v3.0.12.tar.gz"
  sha256 "3341ac841a79544e7645027ab9e920a76971cdb85d1d12b0b67275614418d916"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d2291ec37dd67ba64ec05f94c634f32ebb73dd8924f25692ec4effb91a0dcffc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "10f98589e3460f144aa4bf95d19e5b8e85dcb108e83689026ae55146df91bb9b"
    sha256 cellar: :any_skip_relocation, monterey:       "462668739d255c20a62a590b77b2d0bde19736142a05887e04609492bdd73e8e"
    sha256 cellar: :any_skip_relocation, big_sur:        "f18124bc5f9d0fe21a424b602eae791e3a44cfb768cc999587b29fab05e6b97b"
    sha256 cellar: :any_skip_relocation, catalina:       "072a3223dca5335e6b4a401d34565235f1c1a147e034840efe9d54b62446cacc"
    sha256 cellar: :any_skip_relocation, mojave:         "5aafac5dc491595fd4018f9ae2de79cbeb2aca694c84ddb9ff8fadedbb63f564"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "67b193a65616a29f47549369fdf184f936881aa30e6a941dcaea42e23f771d0d"
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
