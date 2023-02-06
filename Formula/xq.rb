class Xq < Formula
  desc "Command-line XML and HTML beautifier and content extractor"
  homepage "https://github.com/sibprogrammer/xq"
  url "https://github.com/sibprogrammer/xq.git",
      tag:      "v1.1.3",
      revision: "d8708ffb0f5bf0ad3da356733284ade85f758266"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f3b1f7b0cbbc53a8f8d6d16182566c107c8748c9164d4d6522c0d34b12a53a21"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f3b1f7b0cbbc53a8f8d6d16182566c107c8748c9164d4d6522c0d34b12a53a21"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f3b1f7b0cbbc53a8f8d6d16182566c107c8748c9164d4d6522c0d34b12a53a21"
    sha256 cellar: :any_skip_relocation, ventura:        "ea5fd9ca2b045304e7a3002cc1d6879aceb54750cfd53283fbf09dffb9108686"
    sha256 cellar: :any_skip_relocation, monterey:       "ea5fd9ca2b045304e7a3002cc1d6879aceb54750cfd53283fbf09dffb9108686"
    sha256 cellar: :any_skip_relocation, big_sur:        "ea5fd9ca2b045304e7a3002cc1d6879aceb54750cfd53283fbf09dffb9108686"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9a5113dad6492aa4b35f032b1aae841b5a1c0472a3da98a0ae68e4dd36cdd202"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = %W[
      -s -w
      -X main.commit=#{Utils.git_head}
      -X main.version=#{version}
      -X main.date=#{time.iso8601}
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
