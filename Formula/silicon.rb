class Silicon < Formula
  desc "Create beautiful image of your source code"
  homepage "https://github.com/Aloxaf/silicon/"
  url "https://github.com/Aloxaf/silicon/archive/v0.4.0.tar.gz"
  sha256 "423c03d9c92cbad8f5a136abaa680e85dfa5b5f31998aab4424c335d4d99b7ab"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "52f4652a0e234859610c0fe2ff510c6360548af5b275182fe42d1db55434d3ee" => :big_sur
    sha256 "3ed95061624448f3cdb724c2ba8e195fabfcbee846fd66dfab08167bc748b562" => :catalina
    sha256 "05a64aecf5f99a0e195aee75422356f0246381df8c11c31b891b223dab487ab7" => :mojave
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
