class Sdns < Formula
  desc "Privacy important, fast, recursive dns resolver server with dnssec support"
  homepage "https://sdns.dev/"
  url "https://github.com/semihalev/sdns/archive/refs/tags/v1.6.5.tar.gz"
  sha256 "907f8b3e9c6a46fc7f0cb9690157eb71a8253f2385c135a3e85c4e81c030c3d1"
  license "MIT"
  head "https://github.com/semihalev/sdns.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a2277c422cd9c19d9459b54bf9cf9b86dcb74a7fe7d8761fa5961a390748fcbd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "532141c365f0c90697b2e3aa18d2558a834388234e1d64d5c0484b74a0372e21"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7be4ce5d11fbafb1d4ae5e6d06715038c91d65e5d5cc48490ed01d5df717a486"
    sha256 cellar: :any_skip_relocation, sonoma:        "fa1a9df9c0b6089662f9040fa6e41234d3119ecf8e7430505a84d606b8e65bbf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "694ab43eec0a8d09518d659ed0e0590d6b68b3bebf3803baae2535caeb8be75d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "01c9caab9cbb9bb83b987bac65bbbdb4dc1e474b747c01fabbcd772762ef0541"
  end

  depends_on "go" => :build

  def install
    system "make", "build"
    bin.install "sdns"
  end

  service do
    run [opt_bin/"sdns", "--config", etc/"sdns.conf"]
    keep_alive true
    require_root true
    error_log_path var/"log/sdns.log"
    log_path var/"log/sdns.log"
    working_dir opt_prefix
  end

  test do
    spawn bin/"sdns", "--config", testpath/"sdns.conf"
    sleep 2
    assert_path_exists testpath/"sdns.conf"
  end
end
