class ReFlex < Formula
  desc "Regex-centric, fast and flexible scanner generator for C++"
  homepage "https://www.genivia.com/doc/reflex/html"
  url "https://github.com/Genivia/RE-flex/archive/refs/tags/v6.2.0.tar.gz"
  sha256 "52bb648592e4f3669cd5cc4f1575b57d90ed2a23bf71874b29e6f6f6d171ec2d"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "34c63d8f5e01de9467097c3a4478140b4b3dc49cc74bb104544f31b7947f59a9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7b58c9152ce88118b88bf8dca773330983304fcf6cbad3fc77abec3d22819372"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0e83b06eae401468b52234eb30559cbb45372681271b84d3a0fd7fd1c56c91e0"
    sha256 cellar: :any_skip_relocation, sonoma:        "e8d86e97c11a15cef2045bf472c38f6edac89000c1e02cec87ca4d5aeee1578e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "966112e8bb6e08a419acb1bb8771481fc2cb87dcebd330f33547174322f0d260"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "601aa3725d24e20816433957d9a2fa85f7d0c72941dfb7777e317192355dfdae"
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
