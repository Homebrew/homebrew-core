class TyposCli < Formula
  desc "Source code spell checker"
  homepage "https://github.com/crate-ci/typos"
  url "https://github.com/crate-ci/typos/archive/refs/tags/v1.16.6.tar.gz"
  sha256 "ddb4d0dfa2b2c32dfacdc421bc95bad8650a47273612d15b2741c2fe748b2ec3"
  license any_of: ["Apache-2.0", "MIT"]

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "615a2a00518f23d073be341cf7603212bf5aedc5490a21b4740de48f7b7c4f22"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "128ac1823c6221aaba79aae19bd7c76d6639004e2911ddcec27bc4c9d3ac1b3f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f79ea2aabf8706b9a10f360e973bb625faf48cab9ba3fc99edee7c5fd76c966f"
    sha256 cellar: :any_skip_relocation, ventura:        "a43dca1e99dec008fa567054bafa9c2aa6ca83a1cddff4156a9215c964440548"
    sha256 cellar: :any_skip_relocation, monterey:       "64a376e99dc61fa6cebd02d42b3c5c857b414fc1b98188433734657b0b6b7521"
    sha256 cellar: :any_skip_relocation, big_sur:        "0a5f252ffebd04073cf6a37265acb1c959edae4e28bffb19078bff5f7a122478"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "73c08c0971e081013227830e740f30a99f0a1d04038e8235ecad1605a0255a31"
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
