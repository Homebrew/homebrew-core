class Typstfmt < Formula
  desc "Formatter for typst"
  homepage "https://github.com/astrale-sharp/typstfmt"
  url "https://github.com/astrale-sharp/typstfmt/archive/refs/tags/0.2.10.tar.gz"
  sha256 "5a3f413a428b2590552c2d0ab0ab04c7a745e1cca128844b7b82ea49326d65c4"
  license one_of: ["MIT", "Apache-2.0"]
  head "https://github.com/astrale-sharp/typstfmt.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "840ef206e895decf1e2e6f6d4667f0cb5ffc106720664f8651183ddbfa43942f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "844ad26eecdbd64cc9e98bea828c52772bb45a0f6fdc0e79a8ac8a8092679cc2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "582d6c33840b510206e0e80d85406a2f16de67fdcb93102f480330cb226b81d3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bb0272d469193fa0dadcca3ee4d379204a58774ad69b84ec3330064793fecaa8"
    sha256 cellar: :any_skip_relocation, sonoma:         "f676e54a7b0e56cce946b8da875e5c991490b6d9e25dbd573ce58dc788a0139f"
    sha256 cellar: :any_skip_relocation, ventura:        "73843c71221c4b6ac172f2a3f62f0549841074a7b09ef5ef4794b9c88fd0be3e"
    sha256 cellar: :any_skip_relocation, monterey:       "8bd83b378a237b4be80690c7ad71e7c5609e3b85c6179f0d5a5806179ee1321a"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "86165016420a35d4c382d1d96242e158279d866754c561f27ff2a853349a8147"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "560dc8c7913216f620d70b2322c5c384a756eee645d4db0369d798660fd0feef"
  end

  deprecate! date: "2024-06-08", because: :unmaintained
  disable! date: "2025-06-21", because: :unmaintained

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"Hello.typ").write("Hello World!")
    system bin/"typstfmt", "Hello.typ"

    assert_match version.to_s, shell_output("#{bin}/typstfmt --version")
  end
end
