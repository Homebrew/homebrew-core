class Topiary < Formula
  desc "Uniform formatter for simple languages, as part of the Tree-sitter ecosystem"
  homepage "https://topiary.tweag.io/"
  url "https://github.com/tweag/topiary/archive/refs/tags/v0.7.2.tar.gz"
  sha256 "d0b7b2a19797dc63cb43e8097c8a8967f4504b17f8d0f5b83d80961e85398fb2"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4fec0b290fa5b1d5a86817bfc04fa7b9afb7525a5b01287bee5a634e4f711bc9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "05ac93f7846471e762c3a7ffb7b24a638dd1331c1583d01e8a14bf6d30839486"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c36b649d035da43efea4512273a5427f5acfcf2bed19cb74dadabb072ca9c9b8"
    sha256 cellar: :any_skip_relocation, sonoma:        "659749c795fe3bf467371ae77c89ffac4696a30046d7b2cb6cd3baadfbbec8f5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3c7db82195b2926c7bdb86aba8d489a4f81d12860ff824875559732f553e5c57"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5e5095a59368748756e6868412c940f970335be99d4a00c04bbaca40af77ed5d"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "topiary-cli")

    generate_completions_from_executable(bin/"topiary", "completion")
    share.install "topiary-queries/queries"
  end

  test do
    ENV["TOPIARY_LANGUAGE_DIR"] = share/"queries"

    (testpath/"test.rs").write <<~RUST
      fn main() {
        println!("Hello, world!");
      }
    RUST

    system bin/"topiary", "format", testpath/"test.rs"

    assert_match <<~RUST, File.read("#{testpath}/test.rs")
      fn main() {
          println!("Hello, world!");
      }
    RUST

    assert_match version.to_s, shell_output("#{bin}/topiary --version")
  end
end
