class ReFlex < Formula
  desc "Regex-centric, fast and flexible scanner generator for C++"
  homepage "https://www.genivia.com/doc/reflex/html"
  url "https://github.com/Genivia/RE-flex/archive/refs/tags/v6.5.0.tar.gz"
  sha256 "8497b36da92e28e03c63f7814ad3aebdddccc0b2afaba4579e054d253abe4cdf"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "b163ee9f78f692e44781b5ead29f9eb747b26ed542499912023dcaa1ad0d626e"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "41f6d9d75da03ebb96c6b39798b48defa6d4bead4c2c689b31b458885de18fbb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "0bff40548ff20fa453b51266e3bd65f5106b1e4a7d4da25db6369fd228528d3d"
    sha256 cellar: :any,                 arm64_linux:       "2cac03a849a81d83f4a71c1ef6ff7f0b37cb0c84bc7504e32d8bb31e92218cfa"
    sha256 cellar: :any,                 x86_64_linux:      "e7fd535431674ec30c6a7fd59cfae094c4eec3d3009fb435a4ac3dffe001bd70"
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
