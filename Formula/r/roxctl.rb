class Roxctl < Formula
  desc "CLI for Stackrox"
  homepage "https://www.stackrox.io/"
  url "https://github.com/stackrox/stackrox/archive/refs/tags/4.6.2.tar.gz"
  sha256 "798267fcc9637cdf4d78b307fe0c64d1c8c41014c4fb722a012a2c0fb64dc247"
  license "Apache-2.0"
  head "https://github.com/stackrox/stackrox.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4906ed737d1f375c43dcce2390a5410e696ab0f8bdc411470067056090e4cc39"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6a96e11b74c57b4d7e604f7ccea0d34419e8b4d8f1be7e68fefcce31d1a6ec80"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "da352020b6a22b436612a3649619476dff4cdfd421fa22066579d9d6fced4f0a"
    sha256 cellar: :any_skip_relocation, sonoma:        "948448ddd1278142b8563aab3cd6ef53c90cfd6b5c2a6b2cd5cc4c60d711f9b1"
    sha256 cellar: :any_skip_relocation, ventura:       "d88daaca2c1c0ef9f9414dafcdbe3390577df3ef3c05828739863e7a117e5db6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1b7758fc1e8e0e52e49a6a2cde1945363f28a29d570414b8a7e2585b26075a5a"
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
