class Render < Formula
  desc "Command-line interface for Render"
  homepage "https://render.com/docs/cli"
  url "https://github.com/render-oss/cli/archive/refs/tags/v2.1.3.tar.gz"
  sha256 "68eb2bc7129f14c925ee681f97abccd3b1c926936fcf6c94a168504e9326bbf1"
  license "Apache-2.0"
  head "https://github.com/render-oss/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b58db380f76f4a47467e192a47516a781277648a6a16fd556a316e7ac4ce9f54"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b58db380f76f4a47467e192a47516a781277648a6a16fd556a316e7ac4ce9f54"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b58db380f76f4a47467e192a47516a781277648a6a16fd556a316e7ac4ce9f54"
    sha256 cellar: :any_skip_relocation, sonoma:        "1b0c73f1f61eb4ca10eb7377bc021ee4a3e892c797da74ac401350789b7a7ed4"
    sha256 cellar: :any_skip_relocation, ventura:       "1b0c73f1f61eb4ca10eb7377bc021ee4a3e892c797da74ac401350789b7a7ed4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c05adba8d5c87144c55255d6d85e3c7fd124c7a5bbd1b58be13f4958e4f381a8"
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
