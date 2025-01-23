class Sdns < Formula
  desc "Privacy important, fast, recursive dns resolver server with dnssec support"
  homepage "https://sdns.dev"
  url "https://github.com/semihalev/sdns/archive/refs/tags/v1.3.7.tar.gz"
  sha256 "c062743b1cd76cdb85eda4cf5989008fd83f0b89501fbd30cff00a45a3fbcdd3"
  license "MIT"
  head "https://github.com/semihalev/sdns.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "6f33026b36219e6f928936d8693b812b1732e0ee23270eb3ef58259734794646"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "77b31c757d29ed1f3b34994105290636de6fa65badfcaf449c7761263ab7ed97"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c8fc8d1696f2a5e4e6bbdfd1e93922bc9b1774fb6dfe6cc87843e996cac8ce55"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cc9bd2c46455c53c5ae1294898022f3949abdf7625881423912466ce04ed2a40"
    sha256 cellar: :any_skip_relocation, sonoma:         "658cd98c26fa8a9b974d63a37c797b37eb98453c565de77ea8457c0fed63e103"
    sha256 cellar: :any_skip_relocation, ventura:        "81eea4e9dc65c5dc509c215081084b04f07c98e2b05d6f30ee7f440f1bd75ce5"
    sha256 cellar: :any_skip_relocation, monterey:       "7650be11bb71b04f38e751d034dfe962673417fb08b60dffefa3b39191c310a5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "140d8193992c5015c41db665499fd13a08d3cbfe1673d413e239b9a61922fbe2"
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
