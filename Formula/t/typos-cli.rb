class TyposCli < Formula
  desc "Source code spell checker"
  homepage "https://github.com/crate-ci/typos"
  url "https://github.com/crate-ci/typos/archive/refs/tags/v1.45.0.tar.gz"
  sha256 "f7bd2b353818b4e6a2710c30b11f9d4ec62672d6f0c0f7186f6e84140f290d2a"
  license any_of: ["Apache-2.0", "MIT"]

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e832487f8d6375f335a0949b9f586575d569015c546df81f9b0991d16fffd90e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a6b4dfa758f9ba4d29a8791e70e5f15a74e7d8ebdde0746fa1c26af7d06467c4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "158896f6c20fc15486b8dcfec4514b1170cd829a662cfc3ab7929c806d682cf8"
    sha256 cellar: :any_skip_relocation, sonoma:        "f64b8bf29794d660a41e32ce3f4b4c3dcacf763506a545f753e59a6cbe720083"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "53229bbdec7035124289024a5beb2c007feec85e6d386329cf769f7de7e6843b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1ede29533307ce09fc83b6bc7245afb5e848f0389841b3adc9c884f55a61615b"
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
