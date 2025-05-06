class Roxctl < Formula
  desc "CLI for Stackrox"
  homepage "https://www.stackrox.io/"
  url "https://github.com/stackrox/stackrox/archive/refs/tags/4.7.2.tar.gz"
  sha256 "cf810c876d7b0519ce9ea0662c8d42962d95f3f76e995d8c8849460ecf0da34b"
  license "Apache-2.0"
  head "https://github.com/stackrox/stackrox.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7fd6fc84cc8911454aa3c80038ef458b7c301e6f12824b8250e35bff687e9af5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "11bc4fc2c18b5bfacb8422a1abd4b141ebd5f0c5626f2f2fbc637a30c5de9e99"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "97fe83918261beb043d43aab66d94e78c6726a7d42c22ba6e7f27e432546ef53"
    sha256 cellar: :any_skip_relocation, sonoma:        "aa8637b95dd437fa47b3ab98c0042a4648541a5807b830fe32548ab8d11e2075"
    sha256 cellar: :any_skip_relocation, ventura:       "9a4bde0023cd16c1e9ae65688145cb76a96d1c708dd602e9ffa4c9277ec4f41c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fed2f79484a5547e8e6f097fda87a6fbb7d4f375ea4559a3fe896be5847b2627"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f831de84e06706b3017b5910864e4c33c98527d55f82d33addf13301bc54aabf"
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
