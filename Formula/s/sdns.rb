class Sdns < Formula
  desc "Privacy important, fast, recursive dns resolver server with dnssec support"
  homepage "https://sdns.dev/"
  url "https://github.com/semihalev/sdns/archive/refs/tags/v1.7.0.tar.gz"
  sha256 "e67c8944998ffd6c7ab443cc11be1aff69256696bbab2be74169b0f8210392e7"
  license "MIT"
  head "https://github.com/semihalev/sdns.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "afa7e57d55198261d50806e0a162bb9c8385891af28bd16a52ca59c4687a704d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a2b9de36873821561d15754a1bc863f68f83df2c324604829701e0c8544b5842"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c7afa0aaad066c6df313838e0aac87466f155311c2d116ff0bfb7825cdb0488a"
    sha256 cellar: :any_skip_relocation, sonoma:        "a0567f409f28223687cdbb9be830baeb359f3b13f48e5681bed0b0ede93509e8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8f1671041ee6fd4146a058f94361af86089cf7e0c3168f5a2d3838f09d5968b3"
    sha256 cellar: :any,                 x86_64_linux:  "b64c14e652e62e40690afaf7da88fe737c986c3b3bb1af2148d42dc8ebf9e85a"
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
