class TyposCli < Formula
  desc "Source code spell checker"
  homepage "https://github.com/crate-ci/typos"
  url "https://github.com/crate-ci/typos/archive/refs/tags/v1.42.1.tar.gz"
  sha256 "af94843cb533413bdf28b7d4fbd329adc4fc1498e7ef772776d9e00c58f6ac21"
  license any_of: ["Apache-2.0", "MIT"]

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "16e9d60d6caae4f48330aa88057ab7f1bab647486d4a4c69b723107f9c3231c8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8a8f52c49f74a8ee1f7fb78afb0f3f236f0da13f0f11667425edd90b80ba057e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "95a2b6284f70c321e462a9385a9b6c0390d2b52c13fb1ea78365c22eef12ca8a"
    sha256 cellar: :any_skip_relocation, sonoma:        "464ae6415486c56bd2a0059342702da3bb39132bfd0eff93d7ba57ca2b961bd8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1d4afda469be2cea83b4d877c15c591cbfd7d3aea22512b8cae49dcd81f6a5d8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e20e924c8f0f97c4ff1637b0c4bde44ad5cd19abaf7df3434ebb73c5006f8e47"
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
