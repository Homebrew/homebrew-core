class TyposCli < Formula
  desc "Source code spell checker"
  homepage "https://github.com/crate-ci/typos"
  url "https://github.com/crate-ci/typos/archive/refs/tags/v1.29.4.tar.gz"
  sha256 "3d3aea798328653c16529d9dac7f0067a3faebd75230d59193afeda668ead93f"
  license any_of: ["Apache-2.0", "MIT"]

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c395602d63037c0eadf6fb3eb0d5073c69b21b9ee3e83d5c8d1a71597315d418"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "22261582e02da8d5d282195776e616ec94ec86d8711b487b19974440f90c5fb0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c93c789d20e4c4138a45df786244739f65c4c2dc67f4e29c379503692f689229"
    sha256 cellar: :any_skip_relocation, sonoma:        "10dd2ec5ae2de3e94629987a8ea71328e55532cbf0a0bde7311bfeed583622ca"
    sha256 cellar: :any_skip_relocation, ventura:       "55942bf5e61b734291d1d7032cf942b98c30d1321029aea0efebcf60e3014ce6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b545bf900ceb82f29643308a08ea32f33b94670155930436ac9d7dd0b8999922"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/typos-cli")
  end

  test do
    assert_match "error: `teh` should be `the`", pipe_output("#{bin}/typos -", "teh", 2)
    assert_empty pipe_output("#{bin}/typos -", "the")
  end
end
