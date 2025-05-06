class Ratchet < Formula
  desc "Tool for securing CI/CD workflows with version pinning"
  homepage "https://github.com/sethvargo/ratchet"
  url "https://github.com/sethvargo/ratchet/archive/refs/tags/v0.11.2.tar.gz"
  sha256 "13a3d3cfa3bdaf18da337b9fdff9d40faad0a28bdae4f75f560be1de3684d026"
  license "Apache-2.0"
  head "https://github.com/sethvargo/ratchet.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ae54ad750e8a5bf9e01ead85d287bdca74fda9642c3dcb94f8cb62d51c729f29"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ae54ad750e8a5bf9e01ead85d287bdca74fda9642c3dcb94f8cb62d51c729f29"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ae54ad750e8a5bf9e01ead85d287bdca74fda9642c3dcb94f8cb62d51c729f29"
    sha256 cellar: :any_skip_relocation, sonoma:        "3dfc2fae31bc7b23478902bdca47870574c6ea6fecb487bd6c939fe06cfd35af"
    sha256 cellar: :any_skip_relocation, ventura:       "3dfc2fae31bc7b23478902bdca47870574c6ea6fecb487bd6c939fe06cfd35af"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "24cc05543463b7e9e4d3c98e787868082d8433c0aba8c185137035d5094a80e0"
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
