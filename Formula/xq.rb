class Xq < Formula
  desc "Command-line XML and HTML beautifier and content extractor"
  homepage "https://github.com/sibprogrammer/xq"
  url "https://github.com/sibprogrammer/xq.git",
      tag:      "v1.0.0",
      revision: "21fca280a144fbf34ab1a58efa39acb495a46764"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b90ff156c9344bc291f95a53ba801f9a14674b7e2a3a4e1ce907ce27de6ea0a0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b90ff156c9344bc291f95a53ba801f9a14674b7e2a3a4e1ce907ce27de6ea0a0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b90ff156c9344bc291f95a53ba801f9a14674b7e2a3a4e1ce907ce27de6ea0a0"
    sha256 cellar: :any_skip_relocation, monterey:       "0012342ad22da17f5afa76bfd76e998484b5105c94dd1212cdd328d622ce2831"
    sha256 cellar: :any_skip_relocation, big_sur:        "0012342ad22da17f5afa76bfd76e998484b5105c94dd1212cdd328d622ce2831"
    sha256 cellar: :any_skip_relocation, catalina:       "0012342ad22da17f5afa76bfd76e998484b5105c94dd1212cdd328d622ce2831"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2c736c3393aa0e08a64302b42799f3d400614187d8681dfa174c539683a33102"
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
