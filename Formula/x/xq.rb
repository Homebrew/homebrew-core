class Xq < Formula
  desc "Command-line XML and HTML beautifier and content extractor"
  homepage "https://github.com/sibprogrammer/xq"
  url "https://github.com/sibprogrammer/xq.git",
      tag:      "v1.5.0",
      revision: "e1abbb35e250246385b942d055ba800fe04887d6"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "254665c5dddb0e4c7d78e8eeae3f9402c31a71e5b2c9bbb11ee9b017d085dca4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "254665c5dddb0e4c7d78e8eeae3f9402c31a71e5b2c9bbb11ee9b017d085dca4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "254665c5dddb0e4c7d78e8eeae3f9402c31a71e5b2c9bbb11ee9b017d085dca4"
    sha256 cellar: :any_skip_relocation, sonoma:        "9b83960e853b4fc15f384b970aba16bd581fe56f23b4608000e00f3873607bd1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c532d7a2642810ede92fb6e1cfaa73337dec2354244dbbee57db20e8a0991000"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4cf4645404f4ae9db691c82459b81681d9f15fad9cb8a364259c918003ae6a16"
  end

  depends_on "go" => :build

  conflicts_with "python-yq", because: "both install `xq` binaries"

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = %W[
      -X main.commit=#{Utils.git_head}
      -X main.version=#{version}
      -X main.date=#{time.iso8601}
    ]

    system "go", "build", *std_go_args(ldflags:)
    man1.install "docs/xq.man" => "xq.1"
  end

  test do
    version_output = shell_output("#{bin}/xq --version 2>&1")
    assert_match "xq version #{version}", version_output

    run_output = pipe_output(bin/"xq", "<root></root>")
    assert_match("<root/>", run_output)
  end
end
