class Tldx < Formula
  desc "Domain Availability Research Tool"
  homepage "https://brandonyoung.dev/blog/introducing-tldx/"
  url "https://github.com/brandonyoungdev/tldx/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "4386238735382f341ddafb96b9d92a65324e51b47c2d3bc3d693de86b602cf84"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "51920c6c406e89674136426531052952ba145be18e0539281a4e5d79125d0ead"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "51920c6c406e89674136426531052952ba145be18e0539281a4e5d79125d0ead"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "51920c6c406e89674136426531052952ba145be18e0539281a4e5d79125d0ead"
    sha256 cellar: :any_skip_relocation, sonoma:        "ecbfa8423160f894b974d8007fdd751a02750a80cbd584cbfa4691d867e82e84"
    sha256 cellar: :any_skip_relocation, ventura:       "ecbfa8423160f894b974d8007fdd751a02750a80cbd584cbfa4691d867e82e84"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3c9c922c139bef387eb1e742384a8a442c52c4fac63bb34763f44d0782fe7245"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match "brew.sh is not available", shell_output("#{bin}/tldx brew --tlds sh")
  end
end
