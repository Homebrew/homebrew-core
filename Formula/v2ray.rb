class V2ray < Formula
  desc "Platform for building proxies to bypass network restrictions"
  homepage "https://v2fly.org/"
  url "https://github.com/v2fly/v2ray-core/archive/v4.42.2.tar.gz"
  sha256 "70ffcb2719dd4d692266de75d40009d94a1374ced72546fbd9b0dba33b9bb3ea"
  license all_of: ["MIT", "CC-BY-SA-4.0"]
  head "https://github.com/v2fly/v2ray-core.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "cd3e2af2bfc045ed622ea9b46ce00865560957686514f5de84abb18538e986b3"
    sha256 cellar: :any_skip_relocation, big_sur:       "a045bd37d878fbddc311e4b5e8531a24efc84e3416637af63f613d16c61f3e16"
    sha256 cellar: :any_skip_relocation, catalina:      "fc560d3ffd4c4ec14eb36cd49b6efe4247b323c5fbec7e56f590d720c47dec3e"
    sha256 cellar: :any_skip_relocation, mojave:        "78279973a5e7cede499991139f7865e22747aa8c607fbae9f6045cb3560e6a40"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "63c87aeb08f79f5fb148b7be48cc686f2da50671d73a45637ec8806546efeebe"
  end

  depends_on "go" => :build

  resource "geoip" do
    url "https://github.com/v2fly/geoip/releases/download/202109160028/geoip.dat"
    sha256 "530c8a8490f51eb5c2b9d24e4f4f114341f015a5193422aa20df0cf0cb2f50ca"
  end

  resource "geoip-only-cn-private" do
    url "https://github.com/v2fly/geoip/releases/download/202109160028/geoip-only-cn-private.dat"
    sha256 "19e682d3d56ebab82911ad91f10b45db73058aab2f380cf12a3ba83dea32cf88"
  end

  resource "geosite" do
    url "https://github.com/v2fly/domain-list-community/releases/download/20210920023411/dlc.dat"
    sha256 "523a4e641ff07638f2105a62d900791e21503b579ce6956c07259818dbb22836"
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

    resource("geoip-only-cn-private").stage do
      pkgshare.install "geoip-only-cn-private.dat"
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
