class Yaegi < Formula
  desc "Yet another elegant Go interpreter"
  homepage "https://github.com/traefik/yaegi"
  url "https://github.com/traefik/yaegi/archive/refs/tags/v2.0.0.tar.gz"
  sha256 "ac1e4e7c38a7f2911ca0b7786caaa8998d2ca7f301cfaf3cca536b256af492e1"
  license "Apache-2.0"
  head "https://github.com/traefik/yaegi.git", branch: "master"

  bottle do
    manifest_sha256 "ad665aed3e3a781c93a482705dcc2a8f18716d2117f3e9b9675d27d3fd0a309d"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "47df9341f92b95619835747a931a1b8f76ead51414a2101528b0b3ec8a430d94"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "47df9341f92b95619835747a931a1b8f76ead51414a2101528b0b3ec8a430d94"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "47df9341f92b95619835747a931a1b8f76ead51414a2101528b0b3ec8a430d94"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "1955ee3c3b8a970c0e5f15998422142592de2407c722e669610be675fbeedaaa"
    sha256 cellar: :any,                 x86_64_linux:      "16b03b6271738f00af8fd70c1c4da02892ed97d168b450727d65a81af15a89d2"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.version=#{version}"), "./cmd/yaegi"
  end

  test do
    assert_match "4", pipe_output("#{bin}/yaegi -i", "3 + 1", 0)
  end
end
