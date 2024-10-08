class Riff < Formula
  desc "Diff filter highlighting which line parts have changed"
  homepage "https://github.com/walles/riff"
  url "https://github.com/walles/riff/archive/refs/tags/3.3.3.tar.gz"
  sha256 "8bec04631db1f5485fdd8fccc68463ad353aad5bc3e09e072e1d9f0cc774528b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d9016eb235055abe6375022c67caa21bb10f09704d7277da4a0ebcff1f4493b9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9dcaef201f69d2406fc9a825368e39b7542e1d0f646353d90da3c000eb12eae9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "333f40fb5d4f432503356fe8e5cf49054263394f28bda6a3a7a8060e94a116a1"
    sha256 cellar: :any_skip_relocation, sonoma:        "1b0fc2cee20c26c2ef5eae7e5ef6198aff0f3f9fb01812dd42a97bae590b2e14"
    sha256 cellar: :any_skip_relocation, ventura:       "b6815bf13c0c5b567c905f6ea8f702a6d763c7de5092b33cc7ac29cd22692268"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "718ad272cd96dbce4bbfbbecbcfb0cb9683ae4cda78860c1e8e48c3ea0d341fb"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_empty shell_output("#{bin}/riff /etc/passwd /etc/passwd")
    assert_match version.to_s, shell_output("#{bin}/riff --version")
  end
end
