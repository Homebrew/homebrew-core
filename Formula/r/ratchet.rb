class Ratchet < Formula
  desc "Tool for securing CI/CD workflows with version pinning"
  homepage "https://github.com/sethvargo/ratchet"
  url "https://github.com/sethvargo/ratchet/archive/refs/tags/v0.11.3.tar.gz"
  sha256 "46a9bb0a7f284699fc438713612bf9b619d480254a6c78525103dbf45f1d6ce5"
  license "Apache-2.0"
  head "https://github.com/sethvargo/ratchet.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "49fa18b970518e752110498b373d02d624522c702c0aa04effb7f97ad9c8d3e3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "49fa18b970518e752110498b373d02d624522c702c0aa04effb7f97ad9c8d3e3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "49fa18b970518e752110498b373d02d624522c702c0aa04effb7f97ad9c8d3e3"
    sha256 cellar: :any_skip_relocation, sonoma:        "488704c85b23d71d07fd24f54d20f7edef6c542bebc8c11ac5db0ab6e5a571c7"
    sha256 cellar: :any_skip_relocation, ventura:       "488704c85b23d71d07fd24f54d20f7edef6c542bebc8c11ac5db0ab6e5a571c7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "46ba7b2680cd7aeb5fb0333625cd747975bc71ad549870edc1a995c6d84316f2"
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
    output = shell_output(bin/"ratchet check testdata/github.yml 2>&1", 1)
    assert_match "found 5 unpinned refs", output

    output = shell_output(bin/"ratchet -v 2>&1")
    assert_match "ratchet #{version}", output
  end
end
