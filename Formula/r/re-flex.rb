class ReFlex < Formula
  desc "Regex-centric, fast and flexible scanner generator for C++"
  homepage "https://www.genivia.com/doc/reflex/html"
  url "https://github.com/Genivia/RE-flex/archive/refs/tags/v6.0.0.tar.gz"
  sha256 "488a778577429408a3390b6aeac796eccaaa1297bb7573feccf3b608b9ae9d95"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e91a3cfbf67eec33ca4a48f04c0cfeec98d90276006918049d4078f7d432c710"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fd73a376e5f349bc84f937515f67e019575c7faff08d44d83d9f1025640344fc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c735181cd7b4c1e01cd69ecbbf7726fec1fa0810f954b0dadc736a375e0e6806"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "42ed5e3f6a0687fcc791620a482173ff7851c47f5b8f7e322aa4a3232c89f0bb"
    sha256 cellar: :any_skip_relocation, sonoma:        "3f7f277cb2b2e7a9c39d803d22e0adc07c2b917abac74ef3ceb4f86980373440"
    sha256 cellar: :any_skip_relocation, ventura:       "e8012a5ccafe1183da6036ea631c56de478bb2f49b07b7e91b16afb21e638838"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "439ee2accbe09eb7469cdaed53a10605c0c78dfa77804ad03a84af9e4066010e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1149cb16ee52afef10cc2c5ef4397480d0dab377381a1d9ebc1399cb4c7d872f"
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
