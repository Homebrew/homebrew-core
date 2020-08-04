class Volta < Formula
  desc "JavaScript toolchain manager for reproducible environments"
  homepage "https://volta.sh"
  url "https://github.com/volta-cli/volta.git",
      tag:      "v0.8.5",
      revision: "5159d0ba44e8a7f0f1a99b04d37eca525d739ce8"

  bottle do
    cellar :any_skip_relocation
    sha256 "aba29365ab8dfae0c1e8c7a981baa9bd7a72372c67a4a05714adfc05d2174e39" => :catalina
    sha256 "ded963873999b190068d88f2c1d54494dc8e213370df599e3c156a45f794a314" => :mojave
    sha256 "15ce0db8e62c43ae0ba9e9d847fbb3a77a346c206426e692e384910590876749" => :high_sierra
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
