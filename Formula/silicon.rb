class Silicon < Formula
  desc "Create beautiful image of your source code"
  homepage "https://github.com/Aloxaf/silicon/"
  url "https://github.com/Aloxaf/silicon/archive/v0.4.0.tar.gz"
  sha256 "1534b7b4b5a309cf7f79132f3cd5fd7987642735ca7845efb1ec93df685a402d"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "05e3f41091cd031254d98d33af81d966ca4b83709012101eae9012aea7f729e5" => :big_sur
    sha256 "85ae46889515c69afb54d056aabc2b5e0c96a17dac70b360e409f8904b26366f" => :catalina
    sha256 "75a92b9eb7b41d836aed9adc37edeb45dd5b9d38921155ed60f568cdab97667b" => :mojave
    sha256 "06dac3633cbe5c721ea96eac98fbc1347d62fd78e39a3ed328093d517f3eeb61" => :high_sierra
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
