class Sdns < Formula
  desc "Privacy important, fast, recursive dns resolver server with dnssec support"
  homepage "https://sdns.dev"
  url "https://github.com/semihalev/sdns/archive/v1.2.4.tar.gz"
  sha256 "a02338a680d842d26ea55de04a8707ccbf6a14a26403564856bb1770b4dcb653"
  license "MIT"
  head "https://github.com/semihalev/sdns.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "537f430d321a66b233b5a730f227045f2b88f2d607e38c741350a53d2508b8c4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "acf624e28de38db4d2a9fc1ca382217719646d0e25591504453af303470eb2de"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "378c1205a97507b32f3828f2b8d3f739fc7a538e77559f0d9dbdeb59db39e954"
    sha256 cellar: :any_skip_relocation, ventura:        "2b3f229c43b1662672911e2a550ac468b2ab419d3ee48c57859019050ed69a85"
    sha256 cellar: :any_skip_relocation, monterey:       "3df0281e44438a4b3f7ec7b0e60be1066600131783a33c997ebc8aa990db3a2a"
    sha256 cellar: :any_skip_relocation, big_sur:        "32b29954e622e6775d4edd75e3a9843edfd828a7c2e9e21b7284c001adc2ac33"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d723a330608e49b3d4c6e6531ca3ff96d74589fcba7c7fdb6f089bb7a95f45a7"
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
