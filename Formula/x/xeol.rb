class Xeol < Formula
  desc "Xcanner for end-of-life software in container images, filesystems, and SBOMs"
  homepage "https://github.com/xeol-io/xeol"
  url "https://github.com/xeol-io/xeol/archive/refs/tags/v0.10.0.tar.gz"
  sha256 "c2aba5600b87fbf09404a0e206c2c8d3a3caf248676fa9c25e5d3f706028eaa1"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "519c4128b262741abcb12e1a5a8d8a2a867c3133fa9fdfbf6eecf7da353e0211"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "cedd83abea0035cb312b407afa610f23584d4e6898332c5788f77f333cf60502"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "691960ae6a7f36c1b18e89d780834d80a9ee5d90c6aab3172aa4374c163d0bd8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4e2d3fe8a572e249940831909dfcaf6609f739683c0182c3e74c07668ff0717a"
    sha256 cellar: :any_skip_relocation, sonoma:         "633a99d3f3040cd03de9bd45f84daa69c1085b78818d03bc19ce5a9a0d7f1128"
    sha256 cellar: :any_skip_relocation, ventura:        "070a2e9a67014dd70ce3900a634ce281bebb00a1afe80e831d5dee3696779d46"
    sha256 cellar: :any_skip_relocation, monterey:       "2b18e25123924d3e4023a0013b4a07e4a1ac12f78eadbeff8c26ba488f50c5cc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0046b49460039e6d206c66753d042576b8160e68302f406b9e6c495750d3395b"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.gitCommit=#{tap.user}
      -X main.buildDate=#{time.iso8601}
      -X main.gitDescription=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/xeol"

    generate_completions_from_executable(bin/"xeol", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/xeol version")

    output = shell_output("#{bin}/xeol alpine:latest")
    assert_match "no EOL software has been found", output
  end
end
