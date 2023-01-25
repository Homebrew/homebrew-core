class Xq < Formula
  desc "Command-line XML and HTML beautifier and content extractor"
  homepage "https://github.com/sibprogrammer/xq"
  url "https://github.com/sibprogrammer/xq.git",
      tag:      "v1.1.3",
      revision: "d8708ffb0f5bf0ad3da356733284ade85f758266"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "98fa4bd7978e06568caebb3384c1a8259542832ff93700a66a0c67eaacda2909"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "98fa4bd7978e06568caebb3384c1a8259542832ff93700a66a0c67eaacda2909"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "98fa4bd7978e06568caebb3384c1a8259542832ff93700a66a0c67eaacda2909"
    sha256 cellar: :any_skip_relocation, ventura:        "0026deed91e9ee1fc0317c10fa7cd313db673f70dea84ec013c8e20e1bc91dbb"
    sha256 cellar: :any_skip_relocation, monterey:       "0026deed91e9ee1fc0317c10fa7cd313db673f70dea84ec013c8e20e1bc91dbb"
    sha256 cellar: :any_skip_relocation, big_sur:        "0026deed91e9ee1fc0317c10fa7cd313db673f70dea84ec013c8e20e1bc91dbb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b98157cfd25e92c12149d1ca99e024154b98cc5f963f372c9ac13b4dc5aee998"
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
