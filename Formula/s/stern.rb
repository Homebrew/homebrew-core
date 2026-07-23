class Stern < Formula
  desc "Tail multiple Kubernetes pods & their containers"
  homepage "https://github.com/stern/stern"
  url "https://github.com/stern/stern/archive/refs/tags/v1.34.0.tar.gz"
  sha256 "1cfec22cef9705e68fc46060ba85164af12bd07ede9264bafb67d11400996e71"
  license "Apache-2.0"
  head "https://github.com/stern/stern.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cf87c8b14a3f062463ba7d4608a9472a539d6d3c5812ee0a4f49d3ce28009167"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d50b7ab79b975167e19f75bf68597227ad82881ed46c3ff6a62bb90983748cdb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6cc2f6e3114eff8a51e4c27be9b561539d6e79395cabc65c3268bdc5fed52d5f"
    sha256 cellar: :any_skip_relocation, sonoma:        "0fc9084d111eacf45d4cb9b24d4dbdf2f9f1f019215c305391f6f149062f60c9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "74c91eb1456dd62cb71a8eabd41ce94f33856dd2e3b5db0e82a479acc9275ade"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "93c97d2b2b51afe05b8ce55e30e3e415b96981d32fac68ff985a265286425582"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/stern/stern/cmd.version=#{version}")

    # Install shell completion
    generate_completions_from_executable(bin/"stern", "--completion")
  end

  test do
    assert_match "version: #{version}", shell_output("#{bin}/stern --version")
  end
end
