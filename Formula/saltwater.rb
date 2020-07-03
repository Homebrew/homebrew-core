class Saltwater < Formula
  desc "C compiler written in Rust, with a focus on good error messages"
  homepage "https://github.com/jyn514/saltwater"
  url "https://github.com/jyn514/saltwater/archive/0.10.0.tar.gz"
  sha256 "1aac48c8ff787022238806a6c33dab4cc82553285a247581c10051e966544031"
  head "https://github.com/jyn514/saltwater.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "22f162aeaeadee5578237142dc6c1c0c6b59f01c254f43e92c8ef819fbee1482" => :catalina
    sha256 "f7682593dd59142ee70839a3ea6646761e9cd138e2677e916bb0c5ac80fd9c53" => :mojave
    sha256 "0c0c79c00b92bf9b9bd1bde3ddd0c3681183122fbe39cf31e2cb4e4a971f2d64" => :high_sierra
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"hello.c").write <<-EOS
      int printf(const char *, ...);
      int main() {
        printf("Hello, world!\\n");
      }
    EOS
    system bin/"swcc", "-o", "test", "hello.c"
    assert_match "Hello, world!", shell_output("./test")
  end
end
