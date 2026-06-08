class Recur < Formula
  desc "Retry a command with exponential backoff and jitter"
  homepage "https://github.com/dbohdan/recur"
  url "https://github.com/dbohdan/recur/archive/refs/tags/v3.3.0.tar.gz"
  sha256 "394fd4013755b428708d62dafb39b1f767566b3197ae85686b2bac247763ef67"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e4c24b8b4545201201bd84bb0e471463a64e897491dcbe3880cde57c24efa958"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e4c24b8b4545201201bd84bb0e471463a64e897491dcbe3880cde57c24efa958"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e4c24b8b4545201201bd84bb0e471463a64e897491dcbe3880cde57c24efa958"
    sha256 cellar: :any_skip_relocation, sonoma:        "d02c171c761ce976deb592af90198e5e33ba668ce9628e4307a19b09bfee3f3c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e9317cb24df10674e4ac4c68415fe1fad38d4fb35e6db35cccf8c9e7a1516562"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "531d96ed804cb9e6155ba777873c30ccdfced5f91bc5d5ecfd8a6cb933e2b6a4"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    output = shell_output("#{bin}/recur -c 'attempt == 3' sh -c 'echo $RECUR_ATTEMPT'")
    assert_equal "1\n2\n3\n", output
  end
end
