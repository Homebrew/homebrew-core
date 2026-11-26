class Stu < Formula
  desc "TUI explorer application for Amazon S3 (AWS S3)"
  homepage "https://lusingander.github.io/stu/"
  url "https://github.com/lusingander/stu/archive/refs/tags/v0.8.0.tar.gz"
  sha256 "0e0b95506abe5fc163c9ef08bbd83c07e49d2e6558a8550228eb32a92936347a"
  license "MIT"
  head "https://github.com/lusingander/stu.git", branch: "master"

  bottle do
    manifest_sha256 "af32affebbfe2d3dfc27e774a1dd13fabbebf915b1f565269233216a8b6974f3"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "15ac45177f6cd6f32afbd352b48d12308f92649a8f2925e7d68a0994c5b6013d"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "f69401433b4ee0dcebca657f04daece3a056e36a247d60e0f194f5bcfa0ddf26"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "2683b8f47c7524f46218adc5c3295970fb5a61165f8a9bbe60423a7f785ad631"
    sha256 cellar: :any,                 arm64_linux:       "5b8c215e3eda9188bdda042021a891f3aeda98bb7c6853db46ad338a3ce11f83"
    sha256 cellar: :any,                 x86_64_linux:      "4890e67e9fb50a0d2cbb45ec04dfccbccaa4e3e1fe9077d4d22f481b088374d6"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/stu --version")

    output = shell_output("#{bin}/stu s3://test-bucket 2>&1", 2)
    assert_match "error: unexpected argument 's3://test-bucket' found", output
  end
end
