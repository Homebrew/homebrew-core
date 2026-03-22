class Xq < Formula
  desc "Command-line XML and HTML beautifier and content extractor"
  homepage "https://github.com/sibprogrammer/xq"
  url "https://github.com/sibprogrammer/xq.git",
      tag:      "v1.4.0",
      revision: "02a8c391497a63acbea1c57f036770cef2e87b65"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "44d099153ec4a4be002387d1ad5c3217abe3ef79505690586c958114e6ff19b3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "44d099153ec4a4be002387d1ad5c3217abe3ef79505690586c958114e6ff19b3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "44d099153ec4a4be002387d1ad5c3217abe3ef79505690586c958114e6ff19b3"
    sha256 cellar: :any_skip_relocation, sonoma:        "9837eca65155b5e8d9ac7343865a0aaaf6c4c9da667827b9e2b5a667b00e6c59"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d0d82a46bd720fb0b7d0c963261efc56cdf3588ebb77525324dba58ce8253be1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0a4c75879494e05edd80fd217c005edd65f1580856e9b613ca8f1118a0337f3f"
  end

  depends_on "go" => :build

  conflicts_with "python-yq", because: "both install `xq` binaries"

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
    version_output = shell_output("#{bin}/xq --version 2>&1")
    assert_match "xq version #{version}", version_output

    run_output = pipe_output(bin/"xq", "<root></root>")
    assert_match("<root/>", run_output)
  end
end
