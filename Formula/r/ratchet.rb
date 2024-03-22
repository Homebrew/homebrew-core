class Ratchet < Formula
  desc "Tool for securing CI/CD workflows with version pinning"
  homepage "https://github.com/sethvargo/ratchet"
  url "https://github.com/sethvargo/ratchet/archive/refs/tags/v0.7.0.tar.gz"
  sha256 "b2a27c9d5b5423b786097f750bfeedc86dc9927741968f7d84707236352f1e14"
  license "Apache-2.0"
  head "https://github.com/sethvargo/ratchet.git", branch: "main"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    pkgshare.install "testdata"
  end

  test do
    cp_r pkgshare/"testdata", testpath
    output = shell_output(bin/"ratchet check testdata/github.yml 2>&1", 1)
    assert_match "found 4 unpinned refs", output
  end
end
