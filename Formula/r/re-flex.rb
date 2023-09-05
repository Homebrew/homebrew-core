class ReFlex < Formula
  desc "Regex-centric, fast and flexible scanner generator for C++"
  homepage "https://www.genivia.com/doc/reflex/html"
  url "https://github.com/Genivia/RE-flex/archive/v3.3.8.tar.gz"
  sha256 "c50f8ee84437af4a89f91721441d830098f0d064630237f195e3f17941c8b957"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8a842e5b0c8e1d8f64119132cbd44d6de52f4fc88498a7c0999f7f71a7b4f976"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "09174d6454e890145733286a3c954ef0ff38bf0f728ef734dd9ec16b8de7da7c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "da0bd880f02ecaf7698e7294a6fa3e700c4ad0b522db2bc044ffb801fbb4920b"
    sha256 cellar: :any_skip_relocation, ventura:        "c29bd9c5c1cd07afc45fce089a8c505a84889e3693dc3679c13b6e5f3612812a"
    sha256 cellar: :any_skip_relocation, monterey:       "e8b9968a89a0137a9bcae23c753b68f308824fc2488fd966dd4738a66e88701c"
    sha256 cellar: :any_skip_relocation, big_sur:        "ce3037e203c625a179d0635f4c135d4c6d0fe36ebb2ca859bb70c17340f3a345"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c43662a9148333affd7885b6774c16c3d275419deae7088f85fdf4cdeb9a9e8b"
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
