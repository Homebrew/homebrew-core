class Scilla < Formula
  desc "DNS, subdomain, port, directory enumeration tool"
  homepage "https://github.com/edoardottt/scilla"
  url "https://github.com/edoardottt/scilla/archive/refs/tags/v1.3.1.tar.gz"
  sha256 "244a15a966a9be849ac7f514d0b69137220d920a92a37126fbcf320e642e7e4f"
  license "GPL-3.0-or-later"
  head "https://github.com/edoardottt/scilla.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5e579131e2c41b493e3df24190c43ba8ca77214825c5dc3dca653b6c9a795ec3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5e579131e2c41b493e3df24190c43ba8ca77214825c5dc3dca653b6c9a795ec3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5e579131e2c41b493e3df24190c43ba8ca77214825c5dc3dca653b6c9a795ec3"
    sha256 cellar: :any_skip_relocation, sonoma:        "3fbe9853916a2c00f9b47249d7a96ec65401d85363d148b1462ee85c7e445a8b"
    sha256 cellar: :any_skip_relocation, ventura:       "3fbe9853916a2c00f9b47249d7a96ec65401d85363d148b1462ee85c7e445a8b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c97bdc1e96d5caca0a9b9e7dff9b28ec3d497d58d751d524bda25b89e9194d4a"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/scilla"
  end

  test do
    output = shell_output("#{bin}/scilla dns -target brew.sh")
    assert_match <<~EOS, output
      =====================================================
      target: brew.sh
      ================ SCANNING DNS =======================
    EOS

    assert_match version.to_s, shell_output("#{bin}/scilla --help 2>&1", 1)
  end
end
