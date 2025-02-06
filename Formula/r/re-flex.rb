class ReFlex < Formula
  desc "Regex-centric, fast and flexible scanner generator for C++"
  homepage "https://www.genivia.com/doc/reflex/html"
  url "https://github.com/Genivia/RE-flex/archive/refs/tags/v5.2.2.tar.gz"
  sha256 "be7f4adb3141dcb9079f5431f36f35ed553d972eb76565e3bb36da635d9aa126"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dcb8fc6e2f20aaa82a2b383306ff5a6af2b13bd86b45bfd14c729b91d1ce37a8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ea65d5401cc92ea16b47b2b2baf8a8408990a4580a8d6a995622db4ca0b8c3e9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "074587491cbb7159455da2d7c4f4c4b85de879219ea8c79909b2ef9736257a5d"
    sha256 cellar: :any_skip_relocation, sonoma:        "a8d5474fa2dbffc8def8075d60d1772d9f28e793c43ac191eddad057b548989f"
    sha256 cellar: :any_skip_relocation, ventura:       "8b90f2f1f6899236f7e9ac0af85c3a384a988efc06ae42d84646ab65174d7899"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "070dfef6b8d656a9c93c09147fd81a9ed26a7edbeb3b6090836a73529c2c901d"
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
