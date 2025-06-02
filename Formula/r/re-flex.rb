class ReFlex < Formula
  desc "Regex-centric, fast and flexible scanner generator for C++"
  homepage "https://www.genivia.com/doc/reflex/html"
  url "https://github.com/Genivia/RE-flex/archive/refs/tags/v5.5.0.tar.gz"
  sha256 "9057d0d149259d3706e878c54a9c393ab22c7580f35bbd7ddea56e72db906da2"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5392f526e1af262b2dba7bb256d9c28b91eba0be64312f5c3e7e2d142adeeeab"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "30a294a8558a94aab49f015c0fc938706e9ff22ca0b152ce5159558be0aeeeba"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "096ddf1973454385f5a32f0f40b5c3bfa8cb271424f9e5d5728e950528a0d651"
    sha256 cellar: :any_skip_relocation, sonoma:        "5ae7249954011836464044831c3ba61a3d33c4c2314693cf6b23cd0fc2b4b5d9"
    sha256 cellar: :any_skip_relocation, ventura:       "f5e8b15e768952f1772348ed57eb5cfeeadc27ff091f3e8edbdbfa0e7e6c2a92"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3f1911702d41fda102d0277be10ee048e2fc910228398906f14bd434f0b640f6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d8be16a41e24b9e23524278f86ed366452ddf45e09de53933b2cb6a262ae4525"
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
