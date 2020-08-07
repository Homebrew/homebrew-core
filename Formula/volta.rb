class Volta < Formula
  desc "JavaScript toolchain manager for reproducible environments"
  homepage "https://volta.sh"
  url "https://github.com/volta-cli/volta.git",
      tag:      "v0.8.6",
      revision: "701d036d39cf9686625996f0e319ca89e8db91bc"
  license "BSD-2-Clause"

  bottle do
    cellar :any_skip_relocation
    sha256 "de3294c8c06240334e80c62659555ef619ae3c7777565dc15fa4fc8a128adf02" => :catalina
    sha256 "f6adfe3dc87ee6734499035d7985ae6f56541fa7aad967a69bbb693bd323cabb" => :mojave
    sha256 "3b3984025f650775ee70133827f93d396bcd20c747c0c998d1add6cae11d7704" => :high_sierra
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
