class Silicon < Formula
  desc "Create beautiful image of your source code"
  homepage "https://github.com/Aloxaf/silicon/"
  url "https://github.com/Aloxaf/silicon/archive/v0.4.1.tar.gz"
  sha256 "43c736dce804f91f05f4fff85aaf6f036827278a5d03f35d7c63581a42e6bff3"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, big_sur:  "52f4652a0e234859610c0fe2ff510c6360548af5b275182fe42d1db55434d3ee"
    sha256 cellar: :any_skip_relocation, catalina: "3ed95061624448f3cdb724c2ba8e195fabfcbee846fd66dfab08167bc748b562"
    sha256 cellar: :any_skip_relocation, mojave:   "05a64aecf5f99a0e195aee75422356f0246381df8c11c31b891b223dab487ab7"
  end

  depends_on "rust" => :build

  # Patch the build for big_sur, remove in next release
  patch do
    url "https://github.com/Aloxaf/silicon/commit/b3679c4dd4087040950ff9495d76621f2f0f5d0d.patch?full_index=1"
    sha256 "9d26486421fde04141cba5471910a9d7f7df39f88ef5f58266cdb758f1f88254"
  end

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
