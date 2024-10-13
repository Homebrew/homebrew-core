class Utf8proc < Formula
  desc "Clean C library for processing UTF-8 Unicode data"
  homepage "https://juliastrings.github.io/utf8proc/"
  url "https://github.com/JuliaStrings/utf8proc/archive/refs/tags/v2.9.0.tar.gz"
  sha256 "18c1626e9fc5a2e192311e36b3010bfc698078f692888940f1fa150547abb0c1"
  license all_of: ["MIT", "Unicode-DFS-2015"]
  head "https://github.com/JuliaStrings/utf8proc.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "bb0f9b9e8ef3a4d22803dae4d52ce557f7638d852b5f27d56ffefdf27e2645fc"
    sha256 cellar: :any,                 arm64_sonoma:   "cde8cdd879129b6e34ced18440c8149e180175ef74c42c560d8139382971aeb9"
    sha256 cellar: :any,                 arm64_ventura:  "fb2efcc310a7627642f9dc0e617e6f311b53b286dd8c5bcfbf630ee19525b804"
    sha256 cellar: :any,                 arm64_monterey: "9bedbdf0984e79f7a47a21c5299e9e564e91e0819ef65314b6697f40974ef83c"
    sha256 cellar: :any,                 sonoma:         "f7628ae1bf35bb9ebeb4cc23dad23ecdb2657e6a08fad466749f1a88859772ee"
    sha256 cellar: :any,                 ventura:        "9bf2ae6ade6a7c5c873d8e4947e3511edd209c092cf0ad8c0c4246311a4ba76d"
    sha256 cellar: :any,                 monterey:       "ec9ae8d290f855575f8d756ab08ca28eba8d151182ec14fd6daa8cd102655853"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5ab616bad52f9ad576dfc6d3ea4048a146999e53d810ba10a99c2244c518a0de"
  end

  def install
    system "make", "install", "prefix=#{prefix}"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <string.h>
      #include <utf8proc.h>

      int main() {
        const char *version = utf8proc_version();
        return strnlen(version, sizeof("1.3.1-dev")) > 0 ? 0 : -1;
      }
    EOS

    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lutf8proc", "-o", "test"
    system "./test"
  end
end
