class Restack < Formula
  desc "CLI app"
  homepage "https://github.com/restackio/homebrew-restack"
  url "https://github.com/restackio/cli-bin/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "417463c85f93594e158a72e0c08362b079d2166fbd663a168e78423eee4e7edb"
  license "Apache-2.0"
  head "https://github.com/restackio/cli-bin.git", branch: "v0.1.0"

  def install
    bin.install "restack"
  end

  test do
    assert_match "Restack CLI v0.1.0", shell_output("#{bin}/restack -v", 2)
  end
end
