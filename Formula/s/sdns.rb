class Sdns < Formula
  desc "Privacy important, fast, recursive dns resolver server with dnssec support"
  homepage "https://sdns.dev/"
  url "https://github.com/semihalev/sdns/archive/refs/tags/v1.8.1.tar.gz"
  sha256 "7f20214cf687754b500c7fea22d5c2fc2b4bd193810ad49562fea9bd3db94d81"
  license "MIT"
  head "https://github.com/semihalev/sdns.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a546e5869482224d853b89863d06ad36da222c70b368702cc4a27c62c8ec1a2e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7bf64a42f6b1d225ff6151fd9aebc0d94187bf800228b5c15542c1b44d67bc96"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cf6eaa206a9fb81e53b45d0d75ba801d80a1774a8323a64d39a4a4ae77cac78e"
    sha256 cellar: :any_skip_relocation, sonoma:        "12f75b4c212f8786b3d5f39dc6fef72b91d849448d48c12a7d7356479f8afbfa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c3d5585b6e9133d463dd4a753194d23e564de8c372ae1e25d570026d7fb21f5b"
    sha256 cellar: :any,                 x86_64_linux:  "80381cdb6c72a5b1c6011609688f84a4fbe830e65b897d8227d620f8e779fa13"
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
    require "open3"
    stdout, = Open3.capture3(bin/"sdns", "--config", testpath/"sdns.conf", "--test")
    assert_match "Default config file generated", stdout
    assert_path_exists testpath/"sdns.conf"
  end
end
