class Render < Formula
  desc "Command-line interface for Render"
  homepage "https://render.com/docs/cli"
  url "https://github.com/render-oss/cli/archive/refs/tags/v2.1.1.tar.gz"
  sha256 "3f7cd5a46ee79e0e450b88bc07794ffa535c5b0faa661f611d5ccf7bfd6e4815"
  license "Apache-2.0"
  head "https://github.com/render-oss/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c43cec1399d5875a5dec259bc02e6b871cf3b6b6b887b5568cb4ab3b17396cef"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c43cec1399d5875a5dec259bc02e6b871cf3b6b6b887b5568cb4ab3b17396cef"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c43cec1399d5875a5dec259bc02e6b871cf3b6b6b887b5568cb4ab3b17396cef"
    sha256 cellar: :any_skip_relocation, sonoma:        "ce2dc537b890dac6707edb3827e24ef8406a3e39d17256557add9c8451720a45"
    sha256 cellar: :any_skip_relocation, ventura:       "ce2dc537b890dac6707edb3827e24ef8406a3e39d17256557add9c8451720a45"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ed16ae8e2aa21b28da260dce977afc9efa5f4a813c7c694dfb3c5363190d7571"
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
