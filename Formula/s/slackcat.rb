class Slackcat < Formula
  desc "Command-line utility for posting snippets to Slack"
  homepage "https://github.com/bcicen/slackcat"
  url "https://github.com/bcicen/slackcat/archive/refs/tags/1.7.3.tar.gz"
  sha256 "2e3ed7ad5ab3075a8e80a6a0b08a8c52bb8e6e39f6ab03597f456278bfa7768b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "eaeb71583cd7fbfa42657beffce55a819085a9a4e371e890404403e2e579b8e6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "e7b6ecee653c1b0cf06e619a0ce9a3bc753774fbfac2a695a2ad18d77d15eb17"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4066c904442557a6e928e96374693212809796558ca8fd35df519620b70cdf8e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3056663a7ab0abf18ce63db1cf7dc853be37fcd8aa88e0935bc2c6eef2094437"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f485580b0cf05cf5d7dc4efd6e6dc9aa29545d119ebc843b06d53c84b87f2f29"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f765a9df06043f889342eb317e72648bc4904bea55d5339b69399b3a8b4ec3ff"
    sha256 cellar: :any_skip_relocation, sonoma:         "99108f7bcd890e678f082795c4ae5ba4435b945f2fe8341b3160b3ae97133308"
    sha256 cellar: :any_skip_relocation, ventura:        "6f909ddf90a97c5a2503f056677d2c8c802c6386ebd63cef1b8d4b3385ba6c93"
    sha256 cellar: :any_skip_relocation, monterey:       "e9441a1cadead32172fd7eb5ea6b4416ab09b7dffe04584394bad221ba0c0533"
    sha256 cellar: :any_skip_relocation, big_sur:        "176aa3f2c1f088a0dce065034c8a6d381830679db2425c4b4d690823e0b1e022"
    sha256 cellar: :any_skip_relocation, catalina:       "344233ded56abb6b28a5b4cde44cc58713a63e7a2b49a84b8c47c0ebc9d2d3f6"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "5dbd0c522ab28f8a9f4abcd681ab28a43a1a46e4db8e8f03c3a00d9f25ca2f3d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "96518aa5c2d2ddc1c62a1ee163748bc0909be294eebc290156a6ca1908d6216a"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/slackcat -v")
  end
end
