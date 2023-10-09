class Xq < Formula
  desc "Command-line XML and HTML beautifier and content extractor"
  homepage "https://github.com/sibprogrammer/xq"
  url "https://github.com/sibprogrammer/xq.git",
      tag:      "v1.2.2",
      revision: "2d8ab1bc4a3f266e6a36cd3954cf687ad738a031"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "470737b2c5ac5f3be4d495aec6d561ee4aa806a7b408736e2cb43a47416ecfb5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "470737b2c5ac5f3be4d495aec6d561ee4aa806a7b408736e2cb43a47416ecfb5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "470737b2c5ac5f3be4d495aec6d561ee4aa806a7b408736e2cb43a47416ecfb5"
    sha256 cellar: :any_skip_relocation, sonoma:         "c49ff24cd76d1dfdc796ee8394b71f02854392ed69f3868edd486da3cadbf31d"
    sha256 cellar: :any_skip_relocation, ventura:        "c49ff24cd76d1dfdc796ee8394b71f02854392ed69f3868edd486da3cadbf31d"
    sha256 cellar: :any_skip_relocation, monterey:       "c49ff24cd76d1dfdc796ee8394b71f02854392ed69f3868edd486da3cadbf31d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1df6c4d48616ff54bca099a215611532e72ed0c603f65644ba75bac21b118b85"
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
