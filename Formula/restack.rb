require "formula"

class Restack < Formula
  desc "Restack CLI app"
  homepage "https://github.com/restackio/homebrew-restack"
  url "https://github.com/restackio/cli-bin/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "18bfe33bd8bd429b20912e049c3d5a7dbb0b4f8498fe2394a2680c8c705a6d13"
  head "https://github.com/restackio/cli-bin.git", branch: "v0.1.0"
  license "Apache-2.0"

  def install
    bin.install "restack"
  end

  test do
    assert_match "Restack CLI v0.1.0", shell_output("#{bin}/restack -v", 2)
  end
end
