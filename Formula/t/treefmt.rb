class Treefmt < Formula
  desc "One CLI to format the code tree"
  homepage "https://github.com/numtide/treefmt"
  url "https://github.com/numtide/treefmt/archive/refs/tags/v2.0.5.tar.gz"
  sha256 "40ced3eec35522405208b73b3999e8975c1eec51e215321d2448d1cb8052887a"
  license "MIT"
  head "https://github.com/numtide/treefmt.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "2da9a33f81027f40724c3d9bd9b1c7f77207f4f04a568681d82d6e1319faa729"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "adb1fb8c96c398ca1540fff818c06b41ccb48df46b95166d6986bffa0fb35fe8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "adb1fb8c96c398ca1540fff818c06b41ccb48df46b95166d6986bffa0fb35fe8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "adb1fb8c96c398ca1540fff818c06b41ccb48df46b95166d6986bffa0fb35fe8"
    sha256 cellar: :any_skip_relocation, sonoma:         "a736210d2908c46ccbc8ebde30392819950481ebe364f034cd596f3289eb841b"
    sha256 cellar: :any_skip_relocation, ventura:        "a736210d2908c46ccbc8ebde30392819950481ebe364f034cd596f3289eb841b"
    sha256 cellar: :any_skip_relocation, monterey:       "a736210d2908c46ccbc8ebde30392819950481ebe364f034cd596f3289eb841b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "24f03a26fe2ce747d4fd17e2846c008e7d61464a580db43c3f8df0887d2a10f4"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X git.numtide.com/numtide/treefmt/build.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match "error: could not find [treefmt.toml .treefmt.toml]", shell_output("#{bin}/treefmt 2>&1", 1)
    assert_match version.to_s, shell_output("#{bin}/treefmt --version")
  end
end
