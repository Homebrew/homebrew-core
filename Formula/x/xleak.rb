class Xleak < Formula
  desc "Terminal Excel viewer with an interactive TUI"
  homepage "https://github.com/bgreenwell/xleak"
  url "https://github.com/bgreenwell/xleak/archive/refs/tags/v0.2.2.tar.gz"
  sha256 "afa7f06cac11727547dd786c29231643d85ac9e053c86c1959a9423872300e2b"
  license "MIT"
  head "https://github.com/bgreenwell/xleak.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d159a2260603ed4e2ddd916b963d97c6cd098c89379bcb824a5e6452fcdf7e13"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "14c902b1d5f64f0d6a3beced24255e67683ee625d18d8f85ed871bf9ac677f12"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1f5ddad524ca19b899b013f351c2aaa2dc85b9791df803f09e2df75b7b004441"
    sha256 cellar: :any_skip_relocation, sonoma:        "603fe9800eb8bd9b7b66371558870faffa9bacd87a6510de81b26be103265a31"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1ae2120c013709f2282dba2f5d9645c435edd8a763f2dd0ac22d2cac3c9422b8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8435e972e3009456f15ca4b9d220682936f29c2c6b703f13567c3d76d9bc366c"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/xleak --version")

    resource "testfile" do
      url "https://github.com/chenrui333/github-action-test/releases/download/2025.11.16/test.xlsx"
      sha256 "1231165a2dcf688ba902579f0aafc63fc1481886c2ec7c2aa0b537d9cfd30676"
    end

    testpath.install resource("testfile")
    output = shell_output("#{bin}/xleak #{testpath}/test.xlsx")
    assert_match "Total: 5 rows × 2 columns", output
  end
end
