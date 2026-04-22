class Sesh < Formula
  desc "Smart session manager for the terminal"
  homepage "https://github.com/joshmedeski/sesh"
  url "https://github.com/joshmedeski/sesh/archive/refs/tags/v2.25.0.tar.gz"
  sha256 "567dc40efd48fe6376e5da700373554eb4181a3244731f9cc55747633f457ef7"
  license "MIT"
  head "https://github.com/joshmedeski/sesh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "312f7c35d392469c56d3560411f4c91fe5ffbb941cfd92848110d69a2156d6f2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "312f7c35d392469c56d3560411f4c91fe5ffbb941cfd92848110d69a2156d6f2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "312f7c35d392469c56d3560411f4c91fe5ffbb941cfd92848110d69a2156d6f2"
    sha256 cellar: :any_skip_relocation, sonoma:        "12429ff1f09a0666920cb64d62a6ad5900d01e5f8cf6b9a31e2703f1b61715a3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d663c18399f26cb189f8e2d7b70f32a733b8a4836c5167ab712d888f49d43ed7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c133ce117651c43af6740b3824187d86d915303f318d8a7063de030c825bbf30"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:)
    generate_completions_from_executable(bin/"sesh", shell_parameter_format: :cobra)
  end

  test do
    output = shell_output("#{bin}/sesh root 2>&1", 1)
    assert_match "No root found for session", output

    assert_match version.to_s, shell_output("#{bin}/sesh --version")
  end
end
