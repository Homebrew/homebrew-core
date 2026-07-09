class Sift < Formula
  desc "Fast and powerful open source alternative to grep"
  homepage "https://sift-tool.org/"
  url "https://github.com/svent/sift/archive/refs/tags/v0.9.2.tar.gz"
  sha256 "d6d8274e475f3f1235eb0118a89f981e0f7741b9f27243d679d3ecd76f68fe03"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "63a713de84853df834f46bd90c66c9d7f0f0019a7da4a36a4c5f61a70cdcce46"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "63a713de84853df834f46bd90c66c9d7f0f0019a7da4a36a4c5f61a70cdcce46"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "63a713de84853df834f46bd90c66c9d7f0f0019a7da4a36a4c5f61a70cdcce46"
    sha256 cellar: :any_skip_relocation, sonoma:        "2571fad507ff1f07a220ba56e5eaf470c2fa5b4caf233634a6ce7577c08597a7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "daaa507c3220fe9dac3c0928bd296ceccac26d01ceb53d4cb527efe3e396d79a"
    sha256 cellar: :any,                 x86_64_linux:  "33200f80b266a2f5fefaff559c8bae2a70f5602ad207d24fa30789c4fc261e1e"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.buildVersion=#{version}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    (testpath/"test.txt").write("where is foo\n")
    assert_match "where is foo", shell_output("#{bin}/sift foo #{testpath}")
  end
end
