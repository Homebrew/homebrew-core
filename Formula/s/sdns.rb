class Sdns < Formula
  desc "Privacy important, fast, recursive dns resolver server with dnssec support"
  homepage "https://sdns.dev/"
  url "https://github.com/semihalev/sdns/archive/refs/tags/v1.6.3.tar.gz"
  sha256 "5871abcf5f4c527774381f9b7adac8bf96b6d53f9355c9496786e48ecdc7e9b3"
  license "MIT"
  head "https://github.com/semihalev/sdns.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "00a66264726bc782e8a12fc65eacbb12c666204afaea0035b7778497d1fef9a8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e92f15f0ecc14759cab419a71ba68b70ab6e9793ec96ba5ba863af98920b8c38"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2debbc399093950e00ebbffb9b0fa69f43282ebbb905aa66196af95dbc6ce33e"
    sha256 cellar: :any_skip_relocation, sonoma:        "4b3adf19521633c604f1cb29de9150bdf3fe7a828fe0c3a29f513c395839488b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e93ed5c8adafe9821ca066402a05d094a249eb2884bbf0d8728be9dd2befcabf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "55e2d95ac7846051ea0652c1f23d8355dd2cc5e3c5cea0cf6268ff52faeb1a04"
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
