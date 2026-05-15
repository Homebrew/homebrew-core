class Render < Formula
  desc "Command-line interface for Render"
  homepage "https://render.com/docs/cli"
  url "https://github.com/render-oss/cli/archive/refs/tags/v2.17.0.tar.gz"
  sha256 "1e0da1ddd02003416af8633073b631c4efc43e8d9c7fbf3071161103a962d39a"
  license "Apache-2.0"
  head "https://github.com/render-oss/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5b887056a36922c19185cbe37bcda1a2b84cce701613b33feade8da42b881b9d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5b887056a36922c19185cbe37bcda1a2b84cce701613b33feade8da42b881b9d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5b887056a36922c19185cbe37bcda1a2b84cce701613b33feade8da42b881b9d"
    sha256 cellar: :any_skip_relocation, sonoma:        "6c20b8f35f1dc00cb40046aa4a485dfa79df3a7525334a5175ae13c25f0d9a7c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ba2d54850fd8f7d13d51a8b8ab6209d50d66fd81afc11a491a0745199650ffa9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d6d5bf7b78d353fa5aa0ffda91417a873189cc3f0b69d8350f67e3740376abe4"
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
    assert_match version.to_s, shell_output("#{bin}/render --version")

    output = shell_output("#{bin}/render services -o json 2>&1", 1)
    assert_match "Error: no workspace set. Use `render workspace set` to set a workspace", output
  end
end
