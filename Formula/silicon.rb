class Silicon < Formula
  desc "Create beautiful image of your source code"
  homepage "https://github.com/Aloxaf/silicon/"
  url "https://github.com/Aloxaf/silicon/archive/v0.4.0.tar.gz"
  sha256 "423c03d9c92cbad8f5a136abaa680e85dfa5b5f31998aab4424c335d4d99b7ab"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "3866cffa8bb1ccd6e9ce3f63fb559a2efc3a7cdb4b3dbec990cd31437dc9cd22" => :big_sur
    sha256 "b133bef816d016a66e23685681d60160216731aaeed31e283c8c503995864d41" => :catalina
    sha256 "a868d65423afc011ea9504db035c169300e63bb0cd4a7271314401c8425e4071" => :mojave
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"test.rs").write <<~EOF
      fn factorial(n: u64) -> u64 {
          match n {
              0 => 1,
              _ => n * factorial(n - 1),
          }
      }

      fn main() {
          println!("10! = {}", factorial(10));
      }
    EOF

    system bin/"silicon", "-o", "output.png", "test.rs"
    assert_predicate testpath/"output.png", :exist?
    expected_size = [894, 630]
    assert_equal expected_size, IO.read("output.png")[0x10..0x18].unpack("NN")
  end
end
