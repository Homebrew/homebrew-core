class Stern < Formula
  desc "Tail multiple Kubernetes pods & their containers"
  homepage "https://github.com/stern/stern"
  url "https://github.com/stern/stern/archive/v1.19.0.tar.gz"
  sha256 "1f19f9ec21f07317ce53b333b9633b6b91392f5af6b0fff2657ee1b2a0bae707"
  license "Apache-2.0"
  head "https://github.com/stern/stern.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "2d4eb663c230a5531461272845ebe49b682126aeb271d048a39e336c2a7ecd4f"
    sha256 cellar: :any_skip_relocation, big_sur:       "1cdc09acfdb8ddb9dc2f3865bd330e2dce44743ee9979e8cacc7a89e804e34d3"
    sha256 cellar: :any_skip_relocation, catalina:      "d693aab66a01eef79db5962b1dad628ce53d3061732cd86c06faa76b3000144d"
    sha256 cellar: :any_skip_relocation, mojave:        "e0d9f83aa8ed11f4e1136f37ce1b6671d4ef29b98dee49634a1d50f22a962069"
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-ldflags", "-s -w -X github.com/stern/stern/cmd.version=#{version}", *std_go_args

    # Install shell completion
    output = Utils.safe_popen_read("#{bin}/stern", "--completion=bash")
    (bash_completion/"stern").write output

    output = Utils.safe_popen_read("#{bin}/stern", "--completion=zsh")
    (zsh_completion/"_stern").write output
  end

  test do
    assert_match "version: #{version}", shell_output("#{bin}/stern --version")
  end
end
