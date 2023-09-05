class Sdns < Formula
  desc "Privacy important, fast, recursive dns resolver server with dnssec support"
  homepage "https://sdns.dev"
  url "https://github.com/semihalev/sdns/archive/v1.3.5.tar.gz"
  sha256 "7f25c66fd30d2501a1c028f02f7d9b8d9a222dbd4ec4367ae163fc32f2820991"
  license "MIT"
  head "https://github.com/semihalev/sdns.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2db72f4bc242268228c14aff700bded9c258979acf776a83bcef6faf99d9efdc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7ff40495f1e536d0ca5406a3c24583f9fa2902cc8510b859dff2ebb606c1ab7a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "63f5d2d4a95e9366b6ba56e1b5665c73cd10fc98944a02d35d9f031457d2e799"
    sha256 cellar: :any_skip_relocation, ventura:        "bcf312133b2e6bc720fe54245ca761720f4e1ab93a58a99c714a8bbf3c432004"
    sha256 cellar: :any_skip_relocation, monterey:       "562d73d3c62088f24a3a307a6c575e5ce92a7dfd052fdf3732d19e6c567a592c"
    sha256 cellar: :any_skip_relocation, big_sur:        "e35adcdc17988c5b27fd3d928cf3c962eca1ebf821e4bc984f1478ce0ca09bc2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0b15d61513cba8faa07b85ed6185022a97f9c31af8446ac968e1ca2a5fc72efb"
  end

  depends_on "go" => :build

  def install
    system "make", "build"
    bin.install "sdns"
  end

  service do
    run [opt_bin/"sdns", "-config", etc/"sdns.conf"]
    keep_alive true
    require_root true
    error_log_path var/"log/sdns.log"
    log_path var/"log/sdns.log"
    working_dir opt_prefix
  end

  test do
    fork do
      exec bin/"sdns", "-config", testpath/"sdns.conf"
    end
    sleep(2)
    assert_predicate testpath/"sdns.conf", :exist?
  end
end
