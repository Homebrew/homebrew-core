class Rustscan < Formula
  desc "Modern Day Portscanner"
  homepage "https://github.com/rustscan/rustscan"
  url "https://github.com/RustScan/RustScan/archive/refs/tags/2.3.0.tar.gz"
  sha256 "94bec6a3e737963c084fd2e0853689cd0de06ece2588641fddbea7cf249bf414"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "9125bab3959d6f4c2d408b1e1eb3b365013f764777bdf70d41585ab2ce767d18"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "91ab0e6d0297d772f961246aa1c6fffa182379fcea3f967b96cc1927f3ff02c2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8fa070a09005dfb6dbc06b218030db9092bd5038e8f9edf355492aa89f66174e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "517b007a7c058d158d417f856f3752879b570f31f4cb4711c4793b0e0ae72b1e"
    sha256 cellar: :any_skip_relocation, sonoma:         "536082099ebe613e8fbafabf19f87d5bda509e87a965b970b227fb35c2f0b81c"
    sha256 cellar: :any_skip_relocation, ventura:        "d9fdecdf4f24fd77d3b3c12149202bb6d01367b55c423f49d7f919bdbefb8cf9"
    sha256 cellar: :any_skip_relocation, monterey:       "9b59e0e179c82eee5eb7150039bef4762c3cf4bfec45a120bc6485cb8cc685f8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "39343ed8569cb503ec8f631303302b5a937fb3fdb7c1396639d40566a99891dc"
  end

  depends_on "rust" => :build
  depends_on "nmap"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    refute_match("panic", shell_output("#{bin}/rustscan --greppable -a 127.0.0.1"))
    refute_match("panic", shell_output("#{bin}/rustscan --greppable -a 0.0.0.0"))
  end
end
