class V2ray < Formula
  desc "Platform for building proxies to bypass network restrictions"
  homepage "https://v2fly.org/"
  url "https://github.com/v2fly/v2ray-core/archive/v4.41.1.tar.gz"
  sha256 "9d0ca27b78beba96b8ee00141a3e45d7c706d57b3d7c449d7975a8dec815e327"
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
    url "https://github.com/v2fly/geoip/releases/download/202108120026/geoip.dat"
    sha256 "1568a7f6865e367c52951e0b03cfe6c956b249fcf6f5732cfac98f11da1208bb"
  end

  resource "geosite" do
    url "https://github.com/v2fly/domain-list-community/releases/download/20210814110437/dlc.dat"
    sha256 "cf2da8489617bdf210ca92135fb35eb95b86c98595fd970a244359f7d04ca3a7"
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
