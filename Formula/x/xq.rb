class Xq < Formula
  desc "Command-line XML and HTML beautifier and content extractor"
  homepage "https://github.com/sibprogrammer/xq"
  url "https://github.com/sibprogrammer/xq.git",
      tag:      "v1.2.4",
      revision: "08f46d7f6e6ce087919439a74790734b415ff336"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5ffc01a92f4816483599550d53f73b71770dd8ed46f04419a819fa409a58f9a8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5ffc01a92f4816483599550d53f73b71770dd8ed46f04419a819fa409a58f9a8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5ffc01a92f4816483599550d53f73b71770dd8ed46f04419a819fa409a58f9a8"
    sha256 cellar: :any_skip_relocation, sonoma:         "8d45ce98343c355a287e9cd4781e07b888360586ddb8eab270ebc750b73bf4e9"
    sha256 cellar: :any_skip_relocation, ventura:        "8d45ce98343c355a287e9cd4781e07b888360586ddb8eab270ebc750b73bf4e9"
    sha256 cellar: :any_skip_relocation, monterey:       "8d45ce98343c355a287e9cd4781e07b888360586ddb8eab270ebc750b73bf4e9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f31e98b6eb7629fc55497e06a58862156de25ba3597788ff766528f4cf140d28"
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

    system "go", "build", *std_go_args(ldflags:)
    man1.install "docs/xq.man" => "xq.1"
  end

  test do
    version_output = shell_output(bin/"xq --version 2>&1")
    assert_match "xq version #{version}", version_output

    run_output = pipe_output(bin/"xq", "<root></root>")
    assert_match("<root/>", run_output)
  end
end
