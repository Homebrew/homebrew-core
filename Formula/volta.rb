class Volta < Formula
  desc "JavaScript toolchain manager for reproducible environments"
  homepage "https://volta.sh"
  url "https://github.com/volta-cli/volta.git",
      tag:      "v0.9.1",
      revision: "d2bd691c2dccc75c719441383d092df4b2c231d9"
  license "BSD-2-Clause"

  bottle do
    cellar :any_skip_relocation
    sha256 "7a62d3ce5dd2819248516e9e4907b9a2cca7d3c1f7746fb8ac0d8cae8264c9e9" => :catalina
    sha256 "f980cd9db6d7d4a73f3048e91d0e73f9294be5794804e0f96a3fdec207520d44" => :mojave
    sha256 "1d55af69d4a95a02b1a390c1062b2c59f3f1cef3a5d360984790cc16ae56997b" => :high_sierra
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system "#{bin}/volta", "install", "node@12.16.1"
    node = shell_output("#{bin}/volta which node").chomp
    assert_match "12.16.1", shell_output("#{node} --version")
  end
end
