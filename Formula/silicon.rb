class Silicon < Formula
  desc "Create beautiful image of your source code"
  homepage "https://github.com/Aloxaf/silicon/"
  url "https://github.com/Aloxaf/silicon/archive/v0.4.2.tar.gz"
  sha256 "a5fb780ea33ca8e3db038a57efdfc8d4548a832e3eb027671057e6657b5d5294"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "d258ffeb373ddd0d6b6bd36660fdd45a36564536c1fb4f43db5c8f1cc0ae8e28"
    sha256 cellar: :any_skip_relocation, big_sur:       "ed9e6e76ee8b694818de87106ee9c9608781ac5d18f4744ea8d197ba61664fcb"
    sha256 cellar: :any_skip_relocation, catalina:      "59cd0ab050ed82e525ea507063e26c025de1b18cc7a5eac82119f6a4e42747b0"
    sha256 cellar: :any_skip_relocation, mojave:        "4b458312692e17e124910bc35b093da0bf6f45909d3ab0bf06ab74816b27961b"
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
