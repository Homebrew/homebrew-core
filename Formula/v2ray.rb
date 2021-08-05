class V2ray < Formula
  desc "Platform for building proxies to bypass network restrictions"
  homepage "https://v2fly.org/"
  url "https://github.com/v2fly/v2ray-core/archive/v4.40.1.tar.gz"
  sha256 "75b599cb9866c2469056b71f2c0c69cbdab08cf15f6bd2273c893cd0bd16f175"
  license all_of: ["MIT", "CC-BY-SA-4.0"]
  head "https://github.com/v2fly/v2ray-core.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "33829b31999cbf6fc4c7660488339ccf4d2f57a463eb6f4a778d691557c4538c"
    sha256 cellar: :any_skip_relocation, big_sur:       "b381ebf20db3835ea4f78c77e03771cf46cc1b517a041720da913fcfcc42bbae"
    sha256 cellar: :any_skip_relocation, catalina:      "9ac8295e6615d7c551d9182e3ef71ad131be83c43191111bb981e050210088e9"
    sha256 cellar: :any_skip_relocation, mojave:        "3cb91217f610e51779391421229b6126c380f09ff4b169f3b261d09b5763f4e5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6892812312621128ad0a0ce1c70816ccb268cc8a285daac7878a56c306337664"
  end

  depends_on "go" => :build

  resource "geoip" do
    url "https://github.com/v2fly/geoip/releases/download/202106170022/geoip.dat"
    sha256 "af7b0e6b92fa7b1d55b2b9d8155e9a2372b6b0be0e1b9e09353d9859680f6bb1"
  end

  resource "geosite" do
    url "https://github.com/v2fly/domain-list-community/releases/download/20210621183458/dlc.dat"
    sha256 "b78075874cb24c82fd2096e521452ff673fadb3d4d8048da73681f9b4722d0e2"
  end

  def install
    ldflags = "-s -w -buildid="
    execpath = libexec/name
    system "go", "build", *std_go_args, "-o", execpath,
                 "-ldflags", ldflags,
                 "./main"
    system "go", "build", *std_go_args,
                 "-ldflags", ldflags,
                 "-tags", "confonly",
                 "-o", bin/"v2ctl",
                 "./infra/control/main"
    (bin/"v2ray").write_env_script execpath,
      V2RAY_LOCATION_ASSET: "${V2RAY_LOCATION_ASSET:-#{pkgshare}}"

    pkgetc.install "release/config/config.json"

    resource("geoip").stage do
      pkgshare.install "geoip.dat"
    end

    resource("geosite").stage do
      pkgshare.install "dlc.dat" => "geosite.dat"
    end
  end

  service do
    run [bin/"v2ray", "-config", etc/"v2ray/config.json"]
    keep_alive true
  end

  test do
    (testpath/"config.json").write <<~EOS
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
    EOS
    output = shell_output "#{bin}/v2ray -c #{testpath}/config.json -test"

    assert_match "Configuration OK", output
    assert_predicate testpath/"log", :exist?
  end
end
