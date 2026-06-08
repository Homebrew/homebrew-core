class Witr < Formula
  desc "Why is this running?"
  homepage "https://github.com/pranshuparmar/witr"
  url "https://github.com/pranshuparmar/witr/archive/refs/tags/v0.3.2.tar.gz"
  sha256 "4ba1bdb58845aa74a219e905003c3ea604985fd14162c47419954ece2b35410b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "22a3b348b3000c4dbb6aeee0c0fe03c2d780b0c887216c60e9439a65a4a93ca8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "499dad8604be295b8241ac3a7c924f5da5448bfb349c0891642bba34cb93c5b8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2f4f4f5d01820045842e781f8fce20a06af8957453e17c7e475a79981a964393"
    sha256 cellar: :any_skip_relocation, sonoma:        "4f35476656a1339caf64c22c7474aaf75558725e2597ada41fcfb8c17472a1ad"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8d445a1f8e9a47900bd555b7d5516c784b8d76eb3df72ae246593c957e619df7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f33fee6b7fe39c681879b5400691695478ced8119133f52cbe49053d6abe0453"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version} -X main.commit=#{tap.user} -X main.buildDate=#{time.iso8601}"), "./cmd/witr"
    generate_completions_from_executable(bin/"witr", "completion")
    man1.install "docs/cli/witr.1"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/witr --version")
    assert_match "no process ancestry found", shell_output("#{bin}/witr --pid 99999999 2>&1", 2)
  end
end
