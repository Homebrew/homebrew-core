class Ratchet < Formula
  desc "Tool for securing CI/CD workflows with version pinning"
  homepage "https://github.com/sethvargo/ratchet"
  url "https://github.com/sethvargo/ratchet/archive/refs/tags/v0.7.0.tar.gz"
  sha256 "b2a27c9d5b5423b786097f750bfeedc86dc9927741968f7d84707236352f1e14"
  license "Apache-2.0"
  head "https://github.com/sethvargo/ratchet.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "978f7c0cebe6cfe799d7fe131305b352d39aadbd05f98d56fe9805f5de1177cc"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "221c351d07f70a4aa7e13c726e8aabf51915db19417724e691c571d90b6d0dd0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "77da2ad7cc7ab0092fa74ff854e3a224fe0a25b2e8f0b76b0868c1044e8c1d3d"
    sha256 cellar: :any_skip_relocation, sonoma:         "bf0dc347b7e0c09bcfde5e92c5916843c975c4665e524c39c1c2818cfcc0c5cd"
    sha256 cellar: :any_skip_relocation, ventura:        "e744746400fa619f19542488730ce649a9273c4b72a9a37eaaf30946f242ad7e"
    sha256 cellar: :any_skip_relocation, monterey:       "8181c65ffcc0c060c934d17b6cf0297a8186d2adcbde5811419a14d11a241288"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c892298b99cdb6801a5c06339dd58a495f83b5eb2103c2e314f73df0e46ee991"
  end

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
