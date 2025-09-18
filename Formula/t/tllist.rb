class Tllist < Formula
  desc "C header file only implementation of a typed linked list"
  homepage "https://codeberg.org/dnkl/tllist"
  url "https://codeberg.org/dnkl/tllist/archive/1.1.0.tar.gz"
  sha256 "0e7b7094a02550dd80b7243bcffc3671550b0f1d8ba625e4dff52517827d5d23"
  license "MIT"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, all: "77de1b3da7cd1dabd452b4275407c913e1b43152a8617515d3bdee49124a094e"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build

  def install
    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <stdio.h>
      #include <tllist.h>

      int main() {
        tll(int) an_integer_list = tll_init();

        tll_push_back(an_integer_list, 4711);
        tll_push_back(an_integer_list, 1234);

        printf("%zu", tll_length(an_integer_list));
      }
    C

    system ENV.cc, "test.c", "-I#{include}", "-o", "test"

    assert_equal "2", shell_output("./test")
  end
end
