class Volta < Formula
  desc "JavaScript toolchain manager for reproducible environments"
  homepage "https://volta.sh"
  url "https://github.com/volta-cli/volta.git",
      tag:      "v1.0.2",
      revision: "9606139be374266859264c7931e990ad97ae8419"
  license "BSD-2-Clause"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:  "efd062a807d2528c9e900958f0fd34f356972965e9dcd59e2d2438e2d4f0f0f8"
    sha256 cellar: :any_skip_relocation, catalina: "721096bc2ddd9c82f900bdcee57fcdb0cf09e7d8b209ada6889ff478791d553c"
    sha256 cellar: :any_skip_relocation, mojave:   "3f54cb49589eb0bfde6c32a3619c72e141ba842aaceae8bea902d8ab901302cf"
  end

  depends_on "rust" => :build

  uses_from_macos "openssl@1.1"

  on_linux do
    depends_on "pkg-config" => :build
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system "#{bin}/volta", "install", "node@12.16.1"
    node = shell_output("#{bin}/volta which node").chomp
    assert_match "12.16.1", shell_output("#{node} --version")
  end
end
