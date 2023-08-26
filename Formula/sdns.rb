class Sdns < Formula
  desc "Privacy important, fast, recursive dns resolver server with dnssec support"
  homepage "https://sdns.dev"
  url "https://github.com/semihalev/sdns/archive/v1.3.5.tar.gz"
  sha256 "7f25c66fd30d2501a1c028f02f7d9b8d9a222dbd4ec4367ae163fc32f2820991"
  license "MIT"
  head "https://github.com/semihalev/sdns.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "565dcc836fd70a43ce38fc9919b081d83cb6da3d59c865e7617df8ff37d73809"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "aba8aed4fd2ee68e22e929c71ef6bc4446bafe5dd97ea79bc654edee98bc0b4a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "47122a0f132d4b153038060d9bb1c8281d910a7ca94a9d728de657e3f0ac1a0f"
    sha256 cellar: :any_skip_relocation, ventura:        "99724f75a31ba40d7e8131405db6dd2612261a49923458d6abf63344e91cd193"
    sha256 cellar: :any_skip_relocation, monterey:       "a576d0ff9dfff62c90f2043d903d54a4e4b5ed4cc9fcd15f1a5ce05d5529b17a"
    sha256 cellar: :any_skip_relocation, big_sur:        "d1b2753c804f823601ad28727be82666ca023e22db74339d3b9727d8a6b4c957"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a410961579ca2f7af8291fe22c57c1d617c64db0d5c8a564bfee67130812ef6d"
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
