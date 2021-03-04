class Xray < Formula
  desc "Platform for building proxies to bypass network restrictions"
  homepage "https://xtls.github.io/"
  url "https://github.com/XTLS/Xray-core/archive/v1.3.1.tar.gz"
  sha256 "5b860144c470c3f7c6b71ffdf0c3830980f1f6ce431fbe6bf10249c1f0e991a7"
  license all_of: ["MPL-2.0", "CC-BY-SA-4.0"]
  head "https://github.com/XTLS/Xray-core.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  depends_on "go" => :build

  resource "geoip" do
    url "https://github.com/v2fly/geoip/releases/download/202102250625/geoip.dat"
    sha256 "ee41b3c624e27a47b611d7cbee9da605fb9cda7c23bec1326969eb137ca6ebe7"
  end

  resource "geosite" do
    url "https://github.com/v2fly/domain-list-community/releases/download/20210226210728/dlc.dat"
    sha256 "ef9c30bacc6989a0b9fae6043dcef1ec15af96c01eddfa1f1d1ad93d14864f81"
  end

  def install
    ldflags = "-s -w -buildid="
    system "go", "build", *std_go_args,
                 "-ldflags", ldflags,
                 "./main"

    resource("geoip").stage do
      pkgshare.install "geoip.dat"
    end

    resource("geosite").stage do
      pkgshare.install "dlc.dat" => "geosite.dat"
    end
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
            }
          ]
        }
      }
    EOS
    output = shell_output "#{bin}/xray -c #{testpath}/config.json -test"

    assert_match "Configuration OK", output
    assert_predicate testpath/"log", :exist?
  end
end
