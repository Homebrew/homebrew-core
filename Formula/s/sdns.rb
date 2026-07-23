class Sdns < Formula
  desc "Privacy important, fast, recursive dns resolver server with dnssec support"
  homepage "https://sdns.dev/"
  url "https://github.com/semihalev/sdns/archive/refs/tags/v1.7.3.tar.gz"
  sha256 "d9e9a399b5f95ebe6d9c62afff78d21239ccd31210e3b0aeb5fbd9a5516fdf5d"
  license "MIT"
  head "https://github.com/semihalev/sdns.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9afaee7019504752fcc7e8c4afaece6ac141b0824bf4d21d4a9fd86fedf1b53c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "396d451270c4fd68fa043d3ad6debc806baa6d9991c49e39840820b9ac6dab78"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0e6d9ff0e6d0a9b33caa62895592fe570989216cc4f92140b030f469b13f9dc5"
    sha256 cellar: :any_skip_relocation, sonoma:        "9cd7ba32032390769d0e9d32896c7d2c5276db5c2d7dacc3b863aca1962401cf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "31d5490b43c433ea4fcfaf0071f2187385e2c285e996405a8f8519232f4ffd84"
    sha256 cellar: :any,                 x86_64_linux:  "53a432be11774dd7f2764de8c47e09ae83acd2cb2c08c26885981a1e742b3200"
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
