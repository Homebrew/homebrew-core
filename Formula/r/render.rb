class Render < Formula
  desc "Command-line interface for Render"
  homepage "https://render.com/docs/cli"
  url "https://github.com/render-oss/cli/archive/refs/tags/v2.2.0.tar.gz"
  sha256 "6c03f69652f5bd5e8e7adb3d20f987cbf84b33dd7a9a056cd6c8787f658d63dd"
  license "Apache-2.0"
  head "https://github.com/render-oss/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c34ede29423cc4a513148ba4aea56e19dc68ce074222f8825824956e7a9d6772"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c34ede29423cc4a513148ba4aea56e19dc68ce074222f8825824956e7a9d6772"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c34ede29423cc4a513148ba4aea56e19dc68ce074222f8825824956e7a9d6772"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c34ede29423cc4a513148ba4aea56e19dc68ce074222f8825824956e7a9d6772"
    sha256 cellar: :any_skip_relocation, sonoma:        "a5496cd6e026220b0c249ea7279d4bfd9dade3ec4697b14b98fcc717ff61fa4e"
    sha256 cellar: :any_skip_relocation, ventura:       "a5496cd6e026220b0c249ea7279d4bfd9dade3ec4697b14b98fcc717ff61fa4e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2abcd3473f73f9fc8e5581d15c556b658ad22af683ab207a14a9e1f38f9c848a"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/render-oss/cli/pkg/cfg.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    error_msg = "Error: run `render login` to authenticate"
    assert_match error_msg, shell_output("#{bin}/render services -o json 2>&1", 1)
  end
end
