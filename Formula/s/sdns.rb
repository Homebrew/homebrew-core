class Sdns < Formula
  desc "Privacy important, fast, recursive dns resolver server with dnssec support"
  homepage "https://sdns.dev"
  url "https://github.com/semihalev/sdns/archive/v1.3.4.tar.gz"
  sha256 "45757742a584e0413375c0978a15e924106bfef28de0f3b3772c673a1938eea2"
  license "MIT"
  head "https://github.com/semihalev/sdns.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "024ab7e00f70cffc3c5cd1fa76acdc39f909fed282ea809fe7a465e942616fbf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1385eeb3ec1734b88c2516a6f7e25a0a85057be77e1b46b7f31c350721e6ce18"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b3466e55d200e058e525648423818ee8853d37907a43b40dd98c56ef09f62825"
    sha256 cellar: :any_skip_relocation, ventura:        "a6297d3b7574f3dbb1755aa39a43b4a2e5816dd273d20c838fdffcd8e5c30125"
    sha256 cellar: :any_skip_relocation, monterey:       "40d1be0c926ae67da3c3830e7a2ef79c7c5b64cf143e9c80fb2e10ef661ac3a0"
    sha256 cellar: :any_skip_relocation, big_sur:        "89cdaa7d200087ed3dbf0c3ca4e513204dabd27f40439da28f23444a45707498"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "129ef236c430ceb745a96a16a07cbf03a8194062ad967825063dc5dc59dfbd73"
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
