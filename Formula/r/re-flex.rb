class ReFlex < Formula
  desc "Regex-centric, fast and flexible scanner generator for C++"
  homepage "https://www.genivia.com/doc/reflex/html"
  url "https://github.com/Genivia/RE-flex/archive/v3.4.1.tar.gz"
  sha256 "b974c628d30775638e4f530e8c10768df2b2b789735e2599ab9d8a8cc431ceda"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6107e0a0059fecfbe6942378254c2bf5f68411f5eaaa482dc08bcd98d7505977"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fa1ad3dd07a28e2aee1eb5c033761c30f88610266a32ad1b20de8d06c6314282"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bd07f16396363dee586b550f600073a4d052615f8ab5a013ac999ea77ebaae63"
    sha256 cellar: :any_skip_relocation, sonoma:         "bb70329fcf51c671416921050b7928d105357665b5398ee38db031d2750e49de"
    sha256 cellar: :any_skip_relocation, ventura:        "49c00807783a17569cc22d5392afdb322cc6029dd654956ef3a4c1fcf4804389"
    sha256 cellar: :any_skip_relocation, monterey:       "18ff1e88175dcd0e0b04645a4cd238a0e001e7cb9697ea68c267add97051c705"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "59298a705f6fe88e3d897fc8e0b61ba116d7e461efbff65314232a4a63947fd2"
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
