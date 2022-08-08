class Rcodesign < Formula
  desc "Open source implementation of Apple code signing and notarization"
  homepage "https://gregoryszorc.com/docs/apple-codesign/stable/"
  url "https://github.com/indygreg/PyOxidizer/archive/refs/tags/apple-codesign/0.17.0.tar.gz"
  sha256 "3139080097ce3e8d70d05e49f984f5adb4d2fa9a3e095662411422c7c56eba8b"
  license "MPL-2.0"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "apple-codesign")
  end

  test do
    (testpath/"foo.c").write <<~EOS
      #include <stdio.h>
      int main() {
        printf("foo");
        return 0;
      }
    EOS
    (testpath/"bar.c").write <<~EOS
      #include <stdio.h>
      int main() {
        printf("bar");
        return 0;
      }
    EOS
    system ENV.cc, "foo.c", "-o", "foo1"
    system ENV.cc, "foo.c", "-o", "foo2"
    system ENV.cc, "bar.c", "-o", "bar"
    output1 = shell_output("#{bin}/rcodesign compute-code-hashes foo1")
    output2 = shell_output("#{bin}/rcodesign compute-code-hashes foo2")
    output3 = shell_output("#{bin}/rcodesign compute-code-hashes bar")
    assert_equal output1, output2
    refute_equal output1, output3
    refute_equal output2, output3
  end
end
