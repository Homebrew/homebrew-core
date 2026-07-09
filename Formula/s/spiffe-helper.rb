class SpiffeHelper < Formula
  desc "Tool that can be used to retrieve and manage SVIDs on behalf of a workload"
  homepage "https://github.com/spiffe/spiffe-helper"
  url "https://github.com/spiffe/spiffe-helper/archive/refs/tags/v0.11.0.tar.gz"
  sha256 "124b009c0dc737c5e5f7afd11eed4fe41b0ac9b98e98fc51cd1a49b38b3e6090"
  license "Apache-2.0"
  head "https://github.com/spiffe/spiffe-helper.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c489a48d0b8d1593f7badfe5b735b7038ec85fdc573027626ade3c005ee04306"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c489a48d0b8d1593f7badfe5b735b7038ec85fdc573027626ade3c005ee04306"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c489a48d0b8d1593f7badfe5b735b7038ec85fdc573027626ade3c005ee04306"
    sha256 cellar: :any_skip_relocation, sonoma:        "fa6bf56087d81d01a312e2c855fba496e9e3f99d8c526655f6092d783aace956"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cac2dbc3746b6296cb35a00d1ea90a96fe1ca593f52d72cde19b74b66c35c286"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3f2053bc574698df586253d646f5a5324e556b366b01d04f34c238c1aae6ac73"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/spiffe/spiffe-helper/pkg/version.gittag=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/spiffe-helper"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/spiffe-helper -version")

    output = shell_output("#{bin}/spiffe-helper 2>&1", 1)
    assert_match "helper.conf: no such file or directory", output
  end
end
