class Xq < Formula
  desc "Command-line XML and HTML beautifier and content extractor"
  homepage "https://github.com/sibprogrammer/xq"
  url "https://github.com/sibprogrammer/xq.git",
      tag:      "v1.2.1",
      revision: "8ed07bdd6390e64f126abb832bcab0da317f7f34"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2cbb07af6bd4a55df5a4c4ed1db217b81c75f5f07cd7c7968c43192c0e9baec8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2cbb07af6bd4a55df5a4c4ed1db217b81c75f5f07cd7c7968c43192c0e9baec8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2cbb07af6bd4a55df5a4c4ed1db217b81c75f5f07cd7c7968c43192c0e9baec8"
    sha256 cellar: :any_skip_relocation, ventura:        "b60dfc79a740dfc4acbed5b2cb931061bee6d9c1286f9967f640a2ee0a1cb78f"
    sha256 cellar: :any_skip_relocation, monterey:       "b60dfc79a740dfc4acbed5b2cb931061bee6d9c1286f9967f640a2ee0a1cb78f"
    sha256 cellar: :any_skip_relocation, big_sur:        "b60dfc79a740dfc4acbed5b2cb931061bee6d9c1286f9967f640a2ee0a1cb78f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "848e2e0e923439c1c1b8fb7fe527467aa1d492c062529ed3c52b1e7f4a45ee72"
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
