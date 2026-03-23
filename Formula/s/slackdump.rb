class Slackdump < Formula
  desc "Export Slack data without admin privileges"
  homepage "https://github.com/rusq/slackdump"
  url "https://github.com/rusq/slackdump/archive/refs/tags/v4.1.0.tar.gz"
  sha256 "e8d179d90799c560e7624c40ea615f2576f92d15be2f1a8d9b49f7fe007b4a2f"
  license "AGPL-3.0-only"
  head "https://github.com/rusq/slackdump.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8e26cf46da059107e217e43386f9ec089c99c7aeb7fba9067a920ab439ab3b82"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8e26cf46da059107e217e43386f9ec089c99c7aeb7fba9067a920ab439ab3b82"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8e26cf46da059107e217e43386f9ec089c99c7aeb7fba9067a920ab439ab3b82"
    sha256 cellar: :any_skip_relocation, sonoma:        "be70fe0d967971e9d8c3b61db3073ab184a570eae507f018bb436a6fd53e6277"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fe960a4f55504032ecf5bfdb49d85ff0a1ff05d1507d639b23a8e1107633160c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3c7b162047da5cd4adaa9dbf4f27f94277eac6a64c72c8eeb6632f165901338d"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.date=#{time.iso8601} -X main.commit=#{tap.user}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/slackdump"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/slackdump version")

    output = shell_output("#{bin}/slackdump workspace list 2>&1", 9)
    assert_match "(User Error): no authenticated workspaces", output
  end
end
