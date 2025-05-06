class V2ray < Formula
  desc "Platform for building proxies to bypass network restrictions"
  homepage "https://v2fly.org/"
  url "https://github.com/v2fly/v2ray-core/archive/refs/tags/v5.31.0.tar.gz"
  sha256 "20895d4200d3b7906a3fba90690cc2e27239989acc9c31601f40f2f71827e2e5"
  license all_of: ["MIT", "CC-BY-SA-4.0"]
  head "https://github.com/v2fly/v2ray-core.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "67660339b4d20dd4a333037966952f2e49f17f92fc1b580946cbfd0b74d9fe2e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "67660339b4d20dd4a333037966952f2e49f17f92fc1b580946cbfd0b74d9fe2e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "67660339b4d20dd4a333037966952f2e49f17f92fc1b580946cbfd0b74d9fe2e"
    sha256 cellar: :any_skip_relocation, sonoma:        "64673c3b99a4ea98102d6dd7a8bd107b2fe307355168b58bb7a223f805166d29"
    sha256 cellar: :any_skip_relocation, ventura:       "64673c3b99a4ea98102d6dd7a8bd107b2fe307355168b58bb7a223f805166d29"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9b116ec40362e1eff5c4b3f7e45b1e4e7daa6fa0fc5cc2b1e9070bd720ffac6e"
  end

  depends_on "go" => :build

  resource "geoip" do
    url "https://github.com/v2fly/geoip/releases/download/202504050136/geoip.dat"
    sha256 "735786c00694313090c5d525516463836167422b132ce293873443613b496e92"
  end

  resource "geoip-only-cn-private" do
    url "https://github.com/v2fly/geoip/releases/download/202504050136/geoip-only-cn-private.dat"
    sha256 "f1d4e75e3abb42767dda336719d0e63d7b1d80f4aa78958d122da862dce1e365"
  end

  resource "geosite" do
    url "https://github.com/v2fly/domain-list-community/releases/download/20250415151718/dlc.dat"
    sha256 "fc4d21440f7f04e938374a0ab676a147dfb3fac67e59275c7ee3b4ee036638bf"
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
