class Railway < Formula
  desc "Develop and deploy code with zero configuration"
  homepage "https://railway.com/"
  url "https://github.com/railwayapp/cli/archive/refs/tags/v5.50.0.tar.gz"
  sha256 "0ebd315b9f72ceb825f244742d5b5fa4abaa3e9d465a6c860d1c4d2f121fe4a8"
  license "MIT"
  head "https://github.com/railwayapp/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9074be5f23115455e7b248036ca7de9ee0f14de2480d7ab6dbf98449ca7d2c0e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "216555838c2c88a721606d802a18e0f7114a382c09b83b40bd85b87fb43be283"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "998bca1da2d8cc479008ab303c4cc4facb7f646e188cfb6568aab269045d1057"
    sha256 cellar: :any,                 arm64_linux:   "fdbeb4dfbe2abb7ca4e77f2679e50b0f83f4f8ea848471d2b7b26a9346c80132"
    sha256 cellar: :any,                 x86_64_linux:  "e2bdf17b21a618d7e5d0eceaf6fed146ed183c8a31ba8620147732e019f4a9c3"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"railway", "completion")
  end

  test do
    output = shell_output("#{bin}/railway init 2>&1", 1).chomp
    assert_match "Unauthorized. Please login with `railway login`", output

    assert_equal "railway #{version}", shell_output("#{bin}/railway --version").strip
  end
end
