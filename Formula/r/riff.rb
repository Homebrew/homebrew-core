class Riff < Formula
  desc "Diff filter highlighting which line parts have changed"
  homepage "https://github.com/walles/riff"
  url "https://github.com/walles/riff/archive/refs/tags/3.3.4.tar.gz"
  sha256 "da157aa6c3ee506cb0398580289673b69b441fed32708d421f0284e237b4a72f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2fe53aa0d968acb5b03007790bf572081f26eb65c8936aea05ac04c319ccfc2b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "da7fae8c8f82e6f671885c260146101b3982e5ecf9787a1d13fcf056e6b52233"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2535664b4f878faef779a8a1ce5df936e27f475f6dc5f7d4021917dd3b508a17"
    sha256 cellar: :any_skip_relocation, sonoma:        "bba9251a71c3a200393d3eedacb76b15264a9f862252882469180b790bb0b656"
    sha256 cellar: :any_skip_relocation, ventura:       "9235021ba62ae7dad3bf21736a414feb00bf3c985bf6992565989a33b0797175"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2c1281d97ca180810fc2525875e9d356d2a7021e5413f3ae2a7fbca339806fa7"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_empty shell_output("#{bin}/riff /etc/passwd /etc/passwd")
    assert_match version.to_s, shell_output("#{bin}/riff --version")
  end
end
