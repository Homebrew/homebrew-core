class Sdns < Formula
  desc "Privacy important, fast, recursive dns resolver server with dnssec support"
  homepage "https://sdns.dev/"
  url "https://github.com/semihalev/sdns/archive/refs/tags/v1.6.1.tar.gz"
  sha256 "51f8bb52e8651d5c557133391f811a37a0d4679e2758c89dc90100dcfa8314c5"
  license "MIT"
  head "https://github.com/semihalev/sdns.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bf922789a11b285d105a4336f11057654f91b1770b5cfe7c963abbdd7c0bf304"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6c0eaf35e1cc6c935b5336a617cdba0115767bb5d32dfeea587de3c52f5929f7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4e777855d03802cb35b06b0817defe16967ece59413f8d444d625491a352761d"
    sha256 cellar: :any_skip_relocation, sonoma:        "549b928df80acc8c457706f5437fd43192d8efe20948c971e9057231a27c1539"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "39b7338d089d0f02217b80e24d40df74b216eb9fa23a15272ca6d38d5158aed6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8ef3c077c3a3ad44941049282a7190e4818896b7fcc8485c82264aba08f1b432"
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
