class Sdns < Formula
  desc "Privacy important, fast, recursive dns resolver server with dnssec support"
  homepage "https://sdns.dev"
  url "https://github.com/semihalev/sdns/archive/v1.3.0.tar.gz"
  sha256 "09ef2fd114c8f8a86c77bebd7a5238024402ade4f53796e0e8db9cd0aac76fa2"
  license "MIT"
  head "https://github.com/semihalev/sdns.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2825013986cd0adbaa80fca2f016ae03698265b62f4db30ab4261af399f49dcc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f25ab0852c62226d03a109350bd781d34bee31f4a8a65091f6a4206f2658a640"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5038da6d4feaa751ecd2ccf3308ba82a165cec651149dd7738d3bfdc741d1fc1"
    sha256 cellar: :any_skip_relocation, ventura:        "2155f32a8f27c4de7705fb316b16d9035e2ed19ea1cb93a9d3316aeea695fdef"
    sha256 cellar: :any_skip_relocation, monterey:       "2e89e7693e00fbbcba4a819bc6c8e52c7af6220137878c12b984966e83ecb992"
    sha256 cellar: :any_skip_relocation, big_sur:        "e8e4faa690be3a0443e37caec97f32b14853bb79a9d119f54d0a37a9661bbf00"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8c25c27b8093fb45d827981b1571159aafb0af8f723a6ee8e1f509511f221cb2"
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
