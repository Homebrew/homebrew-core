class Sdns < Formula
  desc "Privacy important, fast, recursive dns resolver server with dnssec support"
  homepage "https://sdns.dev"
  url "https://github.com/semihalev/sdns/archive/v1.2.1.tar.gz"
  sha256 "1a5796b3ee8fc38315684bc5a2c41c960615de4f56e9c687b9afb00fb613d6e2"
  license "MIT"
  head "https://github.com/semihalev/sdns.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ffa8678de5adf9428ee4735dac90c07837ba0cc8093611c347d66b61de87a984"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "25c936c5f36e663dc1f9adc90ce62959867ad45bfd846f69c6cc27dce5addc1a"
    sha256 cellar: :any_skip_relocation, monterey:       "6852a3843ddee009612e7854ddd8c34b903da5847fe2bb51e5fb8ca744e0bc18"
    sha256 cellar: :any_skip_relocation, big_sur:        "1d4d0fe899038274de869714f4a20584db47cb900b3acc6d1c729adc631ac644"
    sha256 cellar: :any_skip_relocation, catalina:       "580c801b9094cbd4fe78a677877d7058110c135f61b05c3f65542bd7707aa1ff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "26e552ef4270e54f767b8550c5ecb943a16cfc7ef43d49cab7bc94980f0541c3"
  end

  depends_on "go" => :build

  def install
    system "make", "build"
    bin.install "sdns"
  end

  plist_options startup: true

  service do
    run [opt_bin/"sdns", "-config", etc/"sdns.conf"]
    keep_alive true
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
