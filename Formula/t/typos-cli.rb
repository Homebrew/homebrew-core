class TyposCli < Formula
  desc "Source code spell checker"
  homepage "https://github.com/crate-ci/typos"
  url "https://github.com/crate-ci/typos/archive/refs/tags/v1.37.1.tar.gz"
  sha256 "381a7bf3ed9221496313fc6cceae29ce512d0f78fd6ea72abf58baf7738a5b32"
  license any_of: ["Apache-2.0", "MIT"]

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4ed514fc571a258a2db1c40867b2f7dc3f4d1c914ac75c0cebe6aec3319b3e08"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "35bd176808eff514113cba36f78174a5ecdd8b9840a552f0ba3a8b81fcdeff4a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ce1161e83b0bafa4d109a6beedbf914eb10a791070baeb06e8a1caa67395662a"
    sha256 cellar: :any_skip_relocation, sonoma:        "9f1328cc8d2700f1d9283e69164b36542c7ad452d214540a424944a4fca44e38"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7f0ebb692279f7d9857245aa04dcade656b121427dc1e99b65c1af566c2af900"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b801026b759900b88f3650d7aeec35de49672015ae29b338ea869f690ca245bf"
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
