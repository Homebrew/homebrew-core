class Xq < Formula
  desc "Command-line XML and HTML beautifier and content extractor"
  homepage "https://github.com/sibprogrammer/xq"
  url "https://github.com/sibprogrammer/xq.git",
      tag:      "v1.0.0",
      revision: "21fca280a144fbf34ab1a58efa39acb495a46764"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f1274f9e951a45dca87ebed334d426bc90879300dd88a78b24f55af1da2ff56a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f1274f9e951a45dca87ebed334d426bc90879300dd88a78b24f55af1da2ff56a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f1274f9e951a45dca87ebed334d426bc90879300dd88a78b24f55af1da2ff56a"
    sha256 cellar: :any_skip_relocation, ventura:        "9bafb661146051bf917acf4ef0acb7e8f86a1346d64e4464d406684598ca0019"
    sha256 cellar: :any_skip_relocation, monterey:       "9bafb661146051bf917acf4ef0acb7e8f86a1346d64e4464d406684598ca0019"
    sha256 cellar: :any_skip_relocation, big_sur:        "9bafb661146051bf917acf4ef0acb7e8f86a1346d64e4464d406684598ca0019"
    sha256 cellar: :any_skip_relocation, catalina:       "9bafb661146051bf917acf4ef0acb7e8f86a1346d64e4464d406684598ca0019"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "973b7adab7d8b1f756d2459744b270bb38bb189e4005a43cdc071e083a29cce8"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = %W[
      -s -w
      -X main.commit=#{Utils.git_head}
      -X main.version=#{version}
      -X main.date=#{time.rfc3339}
    ]

    system "go", "build", *std_go_args(ldflags: ldflags)
    man1.install "docs/xq.man" => "xq.1"
  end

  test do
    version_output = shell_output(bin/"xq --version 2>&1")
    assert_match "xq version #{version}", version_output

    run_output = pipe_output(bin/"xq", "<root></root>")
    assert_match("<root/>", run_output)
  end
end
