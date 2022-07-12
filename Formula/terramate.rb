class Terramate < Formula
  desc "Managing Terraform stacks with change detections and code generations"
  homepage "https://github.com/mineiros-io/terramate"
  url "https://github.com/mineiros-io/terramate/archive/refs/tags/v0.1.13.tar.gz"
  sha256 "ec780507ce7ddf5eae0a9819f8a8117bbb46184a9d688dcc09c2627926b0e645"
  license "Apache-2.0"
  head "https://github.com/mineiros-io/terramate.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a9fc94592214ec13e3b08599c79d975d2d1d398b3af5d0d12dd14e42e807c742"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c27d4043e1006b97350d25d071807cbdb1bb01cdccb01714c2ed47a1f85984fb"
    sha256 cellar: :any_skip_relocation, monterey:       "d8727372a06dde2fe7eb9be60c38dee050d746e52152d4cbbde2118deda8685b"
    sha256 cellar: :any_skip_relocation, big_sur:        "dd2c8cb1ea35c3d8476bc2feb0f9614863d06ec8432eb050e8aa94ffebdf3be8"
    sha256 cellar: :any_skip_relocation, catalina:       "f9b41d64e84a625e4ef46dbfcdc5fc578933b717d9fef9a6b06dd4e14e66927c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e47464237c7a7a09f38191e80b89a61ea578169681e6fece24c00b4b8e405345"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/terramate"
  end

  test do
    assert_match "project root not found", shell_output("#{bin}/terramate list 2>&1", 1)
    assert_match version.to_s, shell_output("#{bin}/terramate version")
  end
end
