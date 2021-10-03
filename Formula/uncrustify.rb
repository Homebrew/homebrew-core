class Uncrustify < Formula
  desc "Source code beautifier"
  homepage "https://uncrustify.sourceforge.io/"
  url "https://github.com/uncrustify/uncrustify/archive/uncrustify-0.73.0.tar.gz"
  sha256 "2df0326ba8c413d675b796e051d89a318b7c9cccebc993d66466e2e7fd970672"
  license "GPL-2.0-or-later"
  head "https://github.com/uncrustify/uncrustify.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "2dcaa936d7a4059325a7b8ed903de60ff871123c7d1840292737739b64648b46"
    sha256 cellar: :any_skip_relocation, big_sur:       "aeaebd9ff33c221237ba005017f7d62012e82d7a0c9a10102bfa57ca71fb7358"
    sha256 cellar: :any_skip_relocation, catalina:      "4f50d6e3159241c0f561515465d86b771910a2071407b7b5ed7a4f9d70599e3c"
    sha256 cellar: :any_skip_relocation, mojave:        "58f40e9a613182248edb886953f23d3750580388effc02397ce04760d4f227a3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0b67ac94cb04cd58c14ed139a4718c440b4377e7fcf4b278a0313c7e1dcaa4d5"
  end

  depends_on "cmake" => :build

  on_linux do
    depends_on "gcc"
  end

  fails_with gcc: "5"

  # patches from https://github.com/uncrustify/uncrustify/pull/3178
  # and https://github.com/uncrustify/uncrustify/pull/3179 that fix build failures
  # can be removed for 0.74.0
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/52cd74a3a21841bd6dd6bf2d1e95af8e5e5dfa16/uncrustify/uncrustify-0.73.0.patch"
    sha256 "9323551298cf2acdeffaa17737d2762241fd3403121272f0523402781cc750ee"
  end

  def install
    ENV.cxx11

    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
    doc.install (buildpath/"documentation").children
  end

  test do
    (testpath/"t.c").write <<~EOS
      #include <stdio.h>
      int main(void) {return 0;}
    EOS
    expected = <<~EOS
      #include <stdio.h>
      int main(void) {
      \treturn 0;
      }
    EOS

    system "#{bin}/uncrustify", "-c", "#{doc}/htdocs/default.cfg", "t.c"
    assert_equal expected, File.read("#{testpath}/t.c.uncrustify")
  end
end
