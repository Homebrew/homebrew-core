class Volta < Formula
  desc "JavaScript toolchain manager for reproducible environments"
  homepage "https://volta.sh"
  url "https://github.com/volta-cli/volta.git",
      tag:      "v0.9.1",
      revision: "d2bd691c2dccc75c719441383d092df4b2c231d9"
  license "BSD-2-Clause"

  bottle do
    cellar :any_skip_relocation
    sha256 "7e78feb794f305a00ea2416077a825753bd92d2e9c234861f17f9dd230b45f95" => :catalina
    sha256 "53692c1e46c153819af36481a25a4c965b2882314dc49cab67fe76f7522207c7" => :mojave
    sha256 "96a324b46678d338ca975aec3887626bccca4130974600c322dd8c50e7800956" => :high_sierra
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
