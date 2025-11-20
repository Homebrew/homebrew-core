class TodoistCli < Formula
  desc "CLI for Todoist"
  homepage "https://github.com/sachaos/todoist"
  url "https://github.com/sachaos/todoist/archive/refs/tags/v0.22.0.tar.gz"
  sha256 "b8220ec1ec14f298afed0e32e4028067b8833553a6976f99d7ee35b7a75d5a71"
  license "MIT"
  head "https://github.com/sachaos/todoist.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7227b1cc7c159e9ff807f338f78eb623e9ee244e09eaed66ae5a78e4438a9c52"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6b565b7bccb371408be79df4a27dd9cdf2d4338543986746de44b3db83f36046"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6b565b7bccb371408be79df4a27dd9cdf2d4338543986746de44b3db83f36046"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6b565b7bccb371408be79df4a27dd9cdf2d4338543986746de44b3db83f36046"
    sha256 cellar: :any_skip_relocation, sonoma:        "541bfadda568102b4ce50990479db15588312bcf712f507fd8235c989fbb2b5b"
    sha256 cellar: :any_skip_relocation, ventura:       "541bfadda568102b4ce50990479db15588312bcf712f507fd8235c989fbb2b5b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c77e4c07320575b4fa7f62a4df805df7c808a7b45cb90af656c60b9b6e4d25e7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "751b77cecda38891d3cadd3ffaee3b190f033e337ce1312721a4d4b1cfd4a9fc"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(output: bin/"todoist", ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/todoist --version")

    test_config = testpath/".config/todoist/config.json"
    test_config.write <<~JSON
      {
        "token": "test_token"
      }
    JSON
    chmod 0600, test_config

    output = shell_output("#{bin}/todoist list 2>&1")
    assert_match "There is no task.", output
  end
end
