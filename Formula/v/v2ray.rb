class V2ray < Formula
  desc "Platform for building proxies to bypass network restrictions"
  homepage "https://v2fly.org/"
  url "https://github.com/v2fly/v2ray-core/archive/refs/tags/v5.38.0.tar.gz"
  sha256 "6e2412f6d08282ef06e4f3c752db443d782bb2d6cbf525ebbb2f5e2c01759f9e"
  license all_of: ["MIT", "CC-BY-SA-4.0"]
  head "https://github.com/v2fly/v2ray-core.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9b6699829a0e14d214b0f7269db661ef8b1820c362fff18e513844696eb2e812"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9b6699829a0e14d214b0f7269db661ef8b1820c362fff18e513844696eb2e812"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9b6699829a0e14d214b0f7269db661ef8b1820c362fff18e513844696eb2e812"
    sha256 cellar: :any_skip_relocation, sonoma:        "3d6179fb87a999e7d4c51f26a0d93e40651b621c9e92b3b47e7f1dac165f87ed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bd32e5f1d3c7c77f8e89a681907034bd8859b26c87736c5d66f5c11770f9cf8c"
  end

  depends_on "go" => :build

  resource "geoip" do
    url "https://github.com/v2fly/geoip/releases/download/202509050142/geoip.dat"
    sha256 "a01e09150b456cb2f3819d29d6e6c34572420aaee3ff9ef23977c4e9596c20ec"
  end

  resource "geoip-only-cn-private" do
    url "https://github.com/v2fly/geoip/releases/download/202509050142/geoip-only-cn-private.dat"
    sha256 "845483083b4a7a82087d4293e8a190239ae79698012c1a973baac1156f91c4c2"
  end

  resource "geosite" do
    url "https://github.com/v2fly/domain-list-community/releases/download/20250906011216/dlc.dat"
    sha256 "186158b6c2f67ac59e184ed997ebebcef31938be9874eb8a7d5e3854187f4e8d"
  end

  def install
    ldflags = "-s -w -buildid="
    system "go", "build", *std_go_args(ldflags:, output: libexec/"v2ray"), "./main"

    (bin/"v2ray").write_env_script libexec/"v2ray",
      V2RAY_LOCATION_ASSET: "${V2RAY_LOCATION_ASSET:-#{pkgshare}}"

    pkgetc.install "release/config/config.json"

    resource("geoip").stage do
      pkgshare.install "geoip.dat"
    end

    resource("geoip-only-cn-private").stage do
      pkgshare.install "geoip-only-cn-private.dat"
    end

    resource("geosite").stage do
      pkgshare.install "dlc.dat" => "geosite.dat"
    end
  end

  service do
    run [opt_bin/"v2ray", "run", "-config", etc/"v2ray/config.json"]
    keep_alive true
  end

  test do
    (testpath/"config.json").write <<~JSON
      {
        "log": {
          "access": "#{testpath}/log"
        },
        "outbounds": [
          {
            "protocol": "freedom",
            "tag": "direct"
          }
        ],
        "routing": {
          "rules": [
            {
              "ip": [
                "geoip:private"
              ],
              "outboundTag": "direct",
              "type": "field"
            },
            {
              "domains": [
                "geosite:private"
              ],
              "outboundTag": "direct",
              "type": "field"
            }
          ]
        }
      }
    JSON
    output = shell_output "#{bin}/v2ray test -c #{testpath}/config.json"

    assert_match "Configuration OK", output
    assert_path_exists testpath/"log"
  end
end
