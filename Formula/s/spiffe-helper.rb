class SpiffeHelper < Formula
  desc "Tool that can be used to retrieve and manage SVIDs on behalf of a workload"
  homepage "https://github.com/spiffe/spiffe-helper"
  url "https://github.com/spiffe/spiffe-helper/archive/refs/tags/v0.12.3.tar.gz"
  sha256 "c6307f6c25991c9cd2bddec73f4bbee036d29267f2059c43742db4f44fb2dc78"
  license "Apache-2.0"
  head "https://github.com/spiffe/spiffe-helper.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "71d72d6ba0b1924581bcc1911cc2b4d38b583f8a7fefa35af64c570eb60f2c21"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "71d72d6ba0b1924581bcc1911cc2b4d38b583f8a7fefa35af64c570eb60f2c21"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "71d72d6ba0b1924581bcc1911cc2b4d38b583f8a7fefa35af64c570eb60f2c21"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "6a24748150bcc56b8bbdb26c21ec7f87013dfd0026ae3083aeccd44bad6607e1"
    sha256 cellar: :any,                 x86_64_linux:      "a84545f8141181b0f83e81df502ab42825d23343e493339b75e03f565291d7fd"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = "-X github.com/spiffe/spiffe-helper/pkg/version.gittag=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/spiffe-helper"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/spiffe-helper -version")

    output = shell_output("#{bin}/spiffe-helper 2>&1", 1)
    assert_match "helper.conf: no such file or directory", output
  end
end
