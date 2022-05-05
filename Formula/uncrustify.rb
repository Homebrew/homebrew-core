class Uncrustify < Formula
  desc "Source code beautifier"
  homepage "https://uncrustify.sourceforge.io/"
  url "https://github.com/uncrustify/uncrustify/archive/uncrustify-0.75.0.tar.gz"
  sha256 "f4d1bdac7805fc165e99b1001e474d8ce233d91319894f9b4fc8e0964e10d8f6"
  license "GPL-2.0-or-later"
  head "https://github.com/uncrustify/uncrustify.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0c6f05dbc5d1c74f955fbad667a8258ad89b9d1657955c17e262f6bbe353a53f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7fdaef8b0935162c29e8279f7f4559d8c5a8382dd2ce3cf95a9d4dfba6f6ebd2"
    sha256 cellar: :any_skip_relocation, monterey:       "7f5afcca86615e0b5a6ea200faa8f90d07bf0cde70b1e8dd9c7b3c0bb06b255d"
    sha256 cellar: :any_skip_relocation, big_sur:        "9e6d96d4bdb8fa09eb9c02098b02ee8400b8f3c916a5fdfe93bc33b37e9bf103"
    sha256 cellar: :any_skip_relocation, catalina:       "018ad95d5ce9c1f1fb4e390ce3b36fcf67a124307d21d2876cae7f5524f3a72b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "59c736cd3bd26f6c5b96e234fdcc0be031251e2c6e7212d055112ec7f5218339"
  end

  depends_on "cmake" => :build
  uses_from_macos "python" => :build

  on_linux do
    depends_on "gcc"
  end

  fails_with gcc: "5"

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
