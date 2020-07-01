class Saltwater < Formula
  desc "C compiler written in Rust, with a focus on good error messages"
  homepage "https://github.com/jyn514/saltwater"
  url "https://github.com/jyn514/saltwater/archive/0.10.0.tar.gz"
  sha256 "1aac48c8ff787022238806a6c33dab4cc82553285a247581c10051e966544031"
  head "https://github.com/jyn514/saltwater.git"

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
