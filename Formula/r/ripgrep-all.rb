class RipgrepAll < Formula
  desc "Wrapper around ripgrep that adds multiple rich file types"
  homepage "https://github.com/phiresky/ripgrep-all"
  url "https://github.com/phiresky/ripgrep-all/archive/refs/tags/v0.10.6.tar.gz"
  sha256 "06cd619ad6638be206266a77fdf11034dc2dc15d97b3a057b0d6280a17334680"
  license "AGPL-3.0-or-later"
  head "https://github.com/phiresky/ripgrep-all.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "9ca56dfddd20a516d15595624ac9931aa57ba62a8eae1573c950c95d19424c9f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2036831e61b84f77ba55d1e02d9be3cde6e5d696d45bd10b4fbb17b830419a64"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b6db7b666345a08fd47ab3a328b746a937d0dff8b2045d73f2f8a4589567a9ab"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c0d511ae4e4f4c5c4eb4d68a4a0b0eaebee100e0ff164b9dc562c5fce94e21a0"
    sha256 cellar: :any_skip_relocation, sonoma:         "e91435c58cd5563a065f830506dc069a36bc1fae46c930b218feef20d900c8ef"
    sha256 cellar: :any_skip_relocation, ventura:        "73eb0bb280d911bd0ff69eb99196088f69baea927e8907af895ae17bba8da89a"
    sha256 cellar: :any_skip_relocation, monterey:       "5daf59c3d753b18a621e779ee139bd8f57d9d624194325847c18656ecb0f55a1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1339a4b63e0bcbe33b32bbcb4ec11b1cb89430673a986c05e1b2c21fb46a67bc"
  end

  depends_on "rust" => :build
  depends_on "ripgrep"

  uses_from_macos "zip" => :test

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"file.txt").write("Hello World")
    system "zip", "archive.zip", "file.txt"

    output = shell_output("#{bin}/rga 'Hello World' #{testpath}")
    assert_match "Hello World", output
  end
end
