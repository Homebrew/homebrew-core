class V2ray < Formula
  desc "Platform for building proxies to bypass network restrictions"
  homepage "https://v2fly.org/"
  url "https://github.com/v2fly/v2ray-core/archive/refs/tags/v5.53.0.tar.gz"
  sha256 "f2a78ff50ce36c4a577a39016485cdfb835a75137d514a0a5e8e9e983f0d38bb"
  license all_of: ["MIT", "CC-BY-SA-4.0"]
  head "https://github.com/v2fly/v2ray-core.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "22c0316b46881e5f7e1b3cece165b4a60faf558483e6f302533742732a0c4608"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "22c0316b46881e5f7e1b3cece165b4a60faf558483e6f302533742732a0c4608"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "22c0316b46881e5f7e1b3cece165b4a60faf558483e6f302533742732a0c4608"
    sha256 cellar: :any_skip_relocation, sonoma:        "cef7e3f246a4fe6977312b5cfe3168200564a8f23f86969987a1e76e0aa38ed2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "00aff33519cc98b75d42ec6a00a345b3103ae91d5495b5e3288f08ddb0672fe3"
    sha256 cellar: :any,                 x86_64_linux:  "41699aef2b63a7a5e404756997e1fcd8f599f119954401acb2d93eafc97a142f"
  end

  depends_on "go" => :build

  resource "geoip" do
    url "https://github.com/v2fly/geoip/releases/download/202608050239/geoip.dat"
    version "202608050239"
    sha256 "c67bd077eb102cec74fab759b73d17f99275f56af10a87c14d9fd983508f5ce1"

    livecheck do
      url :url
    end
  end

  resource "geoip-only-cn-private" do
    url "https://github.com/v2fly/geoip/releases/download/202608050239/geoip-only-cn-private.dat"
    version "202608050239"
    sha256 "81f4dda453e16cc2f4609318554eac8f61628f7611c6ee773a996519200a3ca1"

    livecheck do
      url :url
    end
  end

  resource "geosite" do
    url "https://github.com/v2fly/domain-list-community/releases/download/20260819144818/dlc.dat"
    version "20260819144818"
    sha256 "f1fad85e66a838669b369f92ed0f02d14d67f8aa035d7d21df932906d50082e9"

    livecheck do
      url :url
    end
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-buildid=", output: libexec/"v2ray"), "./main"

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
