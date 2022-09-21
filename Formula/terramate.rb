class Terramate < Formula
  desc "Managing Terraform stacks with change detections and code generations"
  homepage "https://github.com/mineiros-io/terramate"
  url "https://github.com/mineiros-io/terramate/archive/refs/tags/v0.1.30.tar.gz"
  sha256 "e95b59ad6c837ec11fb2a31573b3c33770918eaa28315b5dbb41158fabde51b8"
  license "Apache-2.0"
  head "https://github.com/mineiros-io/terramate.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "beb34589faeae0de03feac6954e6fc78c7adbe6f521375c4c49fb7e2a6234554"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "190442f1bcd97de6cd4b1cc31a207b7134e7d30f074261f408267503138211f8"
    sha256 cellar: :any_skip_relocation, monterey:       "6d9f8891e7845a662bf4f66ac2c5b3e81ee2ff86cfd89ff4ff33b771930b744b"
    sha256 cellar: :any_skip_relocation, big_sur:        "216cf74c4d5dbf85dd979ae519391b3635d663adf4d3fd431dc2416a862181e7"
    sha256 cellar: :any_skip_relocation, catalina:       "5b9f6768db44ea48e2c64573a7175a2f42381bf5d8b378aa573b0a71b57fc3ab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eafcdd7c916ac79b4d2d552269b5b3585c6722891eddb809b02c41d7533e15b2"
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
