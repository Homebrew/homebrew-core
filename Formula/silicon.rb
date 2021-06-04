class Silicon < Formula
  desc "Create beautiful image of your source code"
  homepage "https://github.com/Aloxaf/silicon/"
  url "https://github.com/Aloxaf/silicon/archive/v0.4.2.tar.gz"
  sha256 "a5fb780ea33ca8e3db038a57efdfc8d4548a832e3eb027671057e6657b5d5294"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "263754894f746da1464ee4b0f9dcdca0aa36d4d65298fc696794b0dd26a89d41"
    sha256 cellar: :any_skip_relocation, big_sur:       "723f536f0dbcfaf9d7045d081630f4fe2a6b3fdacf5acb96961dbf163d256914"
    sha256 cellar: :any_skip_relocation, catalina:      "7310d8a125fd568d0349e18d58341314ba834c5209c4526c6b1cf2496afda185"
    sha256 cellar: :any_skip_relocation, mojave:        "69c3139d3686b14909f21b0e22a216f372ef2495271046c197a4ff36be7cdcf0"
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
