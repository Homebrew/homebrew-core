class Roxctl < Formula
  desc "CLI for Stackrox"
  homepage "https://www.stackrox.io/"
  url "https://github.com/stackrox/stackrox/archive/refs/tags/4.6.1.tar.gz"
  sha256 "ddec0108caf693b198fe2669cfbe1c74a40f434eb2409b77433db8ee5ac9422f"
  license "Apache-2.0"
  head "https://github.com/stackrox/stackrox.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fe9f797e4e9110e1093969ab9b10421d978ac379d4f85f763fffb4cd13c0f17a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b90349be383858f0cc38d97c16f3dd8eeac7a90e363ce25de022025504b0e7b2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a2cb42dc2599e846db06a965939f6c604ef87eea2536b6ab9ebfc9539a97c6b2"
    sha256 cellar: :any_skip_relocation, sonoma:        "fb11bae865a8c3982d3af5fdb851fa070a010c49f3db9247a5853e6752138a3a"
    sha256 cellar: :any_skip_relocation, ventura:       "65e282f9e28282644b64849dc196e4d3a3ced6ceeedfd397b5d6390ccc1f91e0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8c84d82eef67b33ae30ca2f87df75b052b967d950297c23a50bee8e535ef5679"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./roxctl"

    generate_completions_from_executable(bin/"roxctl", "completion")
  end

  test do
    output = shell_output("#{bin}/roxctl central whoami 2<&1", 1)
    assert_match <<~EOS, output
      ERROR:	obtaining auth information for localhost:8443: \
      retrieving token: no credentials found for localhost:8443, please run \
      "roxctl central login" to obtain credentials
    EOS
  end
end
