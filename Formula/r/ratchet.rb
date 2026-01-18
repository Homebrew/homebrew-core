class Ratchet < Formula
  desc "Tool for securing CI/CD workflows with version pinning"
  homepage "https://github.com/sethvargo/ratchet"
  url "https://github.com/sethvargo/ratchet/archive/refs/tags/v0.11.4.tar.gz"
  sha256 "0f1a540f388d2b8633b8203670d6ec8722d47af40055ce79cd1743a731823b2e"
  license "Apache-2.0"
  head "https://github.com/sethvargo/ratchet.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "054e4744b0fac5342afb2e622206d80fdbb1b96e9b21cae1f7a0f8c133ba91f5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "87e9d4f5ece669b81b693c4e13c8d0e66a879fcbc40f99337a0f0e5c3065716d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "87e9d4f5ece669b81b693c4e13c8d0e66a879fcbc40f99337a0f0e5c3065716d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "87e9d4f5ece669b81b693c4e13c8d0e66a879fcbc40f99337a0f0e5c3065716d"
    sha256 cellar: :any_skip_relocation, sonoma:        "0afec9e6ec42dffa7e6c9d5c4119bd21e326f38eeb73dfe212dcbd4deca9f5a4"
    sha256 cellar: :any_skip_relocation, ventura:       "0afec9e6ec42dffa7e6c9d5c4119bd21e326f38eeb73dfe212dcbd4deca9f5a4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "735721ebf63318e966738056cba7806b62a7b2029eb6c8c8c2b512ae6c090723"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d2b32f00ee26be2f4e60855b7f0a71d122df2b94c55509360052d15d7001c167"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s
      -w
      -X=github.com/sethvargo/ratchet/internal/version.version=#{version}
      -X=github.com/sethvargo/ratchet/internal/version.commit=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:)

    pkgshare.install "testdata"
  end

  test do
    cp_r pkgshare/"testdata", testpath
    output = shell_output("#{bin}/ratchet check testdata/github.yml 2>&1", 1)
    assert_match "found 5 unpinned refs", output

    output = shell_output("#{bin}/ratchet -v 2>&1")
    assert_match "ratchet #{version}", output
  end
end
