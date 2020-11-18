class V2ray < Formula
  desc "Platform for building proxies to bypass network restrictions"
  homepage "https://v2fly.org/"
  url "https://github.com/v2fly/v2ray-core/archive/v4.32.1.tar.gz"
  sha256 "f5553ffd04ff226573e8132d9beaa63f4d8f4882eba047225b33620848bc6917"
  license "MIT"
  head "https://github.com/v2fly/v2ray-core.git"

  depends_on "go" => :build

  resource "config" do
    url "https://github.com/v2fly/v2ray-core/raw/v4.32.1/release/config/config.json"
    sha256 "e4498e48725cb8e835aa384b98e494579b1f04059576fdaf43ea0579498b7edd"
  end

  resource "geoip" do
    url "https://github.com/v2fly/geoip/releases/download/202011150541/geoip.dat"
    sha256 "11b7c3bfc5715c42d26b0e4bcf51d38c157eae9ab4b9e8391d702681e385dbcd"
  end

  resource "geosite" do
    url "https://github.com/v2fly/domain-list-community/releases/download/20201117215431/dlc.dat"
    sha256 "32ba60cb90c9f6951e2de12bf3a8e9fd5fbccee4d1706421f1a9413303e75a2e"
  end

  def install
    ENV["GOPATH"] = HOMEBREW_CACHE/"go_cache"
    ENV["CGO_ENABLED"] = "0"
    ldflags = "-s -w -buildid="
    system "go", "build", "-o", bin/"v2ray", "-ldflags", ldflags, "./main"
    system "go", "build", "-o", bin/"v2ctl", "-ldflags", ldflags, "-tags", "confonly", "./infra/control/main"

    resource("config").stage do
      (etc/"v2ray").install "config.json"
    end

    resource("geoip").stage do
      (etc/"v2ray").install "geoip.dat"
    end

    resource("geosite").stage do
      (etc/"v2ray").install "dlc.dat" => "geosite.dat"
    end
  end

  test do
    assert_match "V2Ray", shell_output("#{bin}/v2ray -version")
  end
end
