class Tldx < Formula
  desc "Domain Availability Research Tool"
  homepage "https://brandonyoung.dev/blog/introducing-tldx/"
  url "https://github.com/brandonyoungdev/tldx/archive/refs/tags/v1.2.5.tar.gz"
  sha256 "fd137e59e495da1458cb3ff44be62af63856096a5f9a1879bc6d311fed62ca86"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "601038f524b47d16d4319d58e6056352719a8cccc5d3e974a5bda068d71972e8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "601038f524b47d16d4319d58e6056352719a8cccc5d3e974a5bda068d71972e8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "601038f524b47d16d4319d58e6056352719a8cccc5d3e974a5bda068d71972e8"
    sha256 cellar: :any_skip_relocation, sonoma:        "28b61e4691c67f1d03494cdae2c991436d85839d55cfbf33829c8d9b0d70c706"
    sha256 cellar: :any_skip_relocation, ventura:       "28b61e4691c67f1d03494cdae2c991436d85839d55cfbf33829c8d9b0d70c706"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e2d84492fbcd19f69a130d5d17a4847f33e454ca03cdf8e782d9adfe0022c030"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/brandonyoungdev/tldx/cmd.Version=#{version}")
  end

  test do
    assert_match "brew.sh is not available", shell_output("#{bin}/tldx brew --tlds sh")

    assert_match version.to_s, shell_output("#{bin}/tldx --version")
  end
end
