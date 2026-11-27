class Yaegi < Formula
  desc "Yet another elegant Go interpreter"
  homepage "https://github.com/traefik/yaegi"
  url "https://github.com/traefik/yaegi/archive/refs/tags/v2.0.1.tar.gz"
  sha256 "5ddd97fa64f9135f2741d2177f07e6ca8a7a52b01413c3ffd3199c27b7a2b64a"
  license "Apache-2.0"
  head "https://github.com/traefik/yaegi.git", branch: "master"

  bottle do
    manifest_sha256 "b41fac046b82d8e3b0f15dfa1f72266644fa6c6c962814a9855a05406e34c431"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "5a8d4df6c2a05c1fc33940ff46c81310b3385a392cde4667ad14affb431f9148"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "5a8d4df6c2a05c1fc33940ff46c81310b3385a392cde4667ad14affb431f9148"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "5a8d4df6c2a05c1fc33940ff46c81310b3385a392cde4667ad14affb431f9148"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "4849f9b4ee9626eb7f6d5a5d0177bc00adc58afea4aeab01774cffb900c001d4"
    sha256 cellar: :any,                 x86_64_linux:      "72a03f367386770bb54e9a2326ebb22f0c7e0e423156770588caf3bf33fcd9e4"
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
