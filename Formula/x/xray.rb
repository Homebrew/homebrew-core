class Xray < Formula
  desc "Platform for building proxies to bypass network restrictions"
  homepage "https://xtls.github.io/"
  url "https://github.com/XTLS/Xray-core/archive/refs/tags/v25.5.16.tar.gz"
  sha256 "c856cd9abed7d28d3c7b856c0661cec5c85ba0669affa740c979cf40c2f73ee4"
  license all_of: ["MPL-2.0", "CC-BY-SA-4.0"]
  head "https://github.com/XTLS/Xray-core.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e1e778492bc1119a5675cd15a7481d155822a431b87f412fe8b4fe31681cd60e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e1e778492bc1119a5675cd15a7481d155822a431b87f412fe8b4fe31681cd60e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e1e778492bc1119a5675cd15a7481d155822a431b87f412fe8b4fe31681cd60e"
    sha256 cellar: :any_skip_relocation, sonoma:        "0d5bba1bf75d922ebc48892ee6259ec81306d10c6772377806cba4d231a38624"
    sha256 cellar: :any_skip_relocation, ventura:       "0d5bba1bf75d922ebc48892ee6259ec81306d10c6772377806cba4d231a38624"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6eafd0e37c03de62a0c567b23cd6c044ce0db56b80edd8e0d841ef03990b3859"
  end

  depends_on "go" => :build

  resource "geoip" do
    url "https://github.com/v2fly/geoip/releases/download/202505050146/geoip.dat"
    sha256 "8023379316bca4713dcfa5ba4ea2fe7f4c127fff64a0cb7859d4756142b2c4dc"
  end

  resource "geosite" do
    url "https://github.com/v2fly/domain-list-community/releases/download/20250508005311/dlc.dat"
    sha256 "ff833c7e95d0dadb97ba7d96598563d159fabb0b774dcebea15f335797259f42"
  end

  resource "example_config" do
    # borrow v2ray example config
    url "https://raw.githubusercontent.com/v2fly/v2ray-core/v5.31.0/release/config/config.json"
    sha256 "15a66415d72df4cd77fcd037121f36604db244dcfa7d45d82a0c33de065c6a87"

    livecheck do
      url "https://github.com/v2fly/v2ray-core.git"
    end
  end

  def install
    ldflags = "-s -w -buildid="
    execpath = libexec/name
    system "go", "build", *std_go_args(output: execpath, ldflags:), "./main"
    (bin/"xray").write_env_script execpath,
      XRAY_LOCATION_ASSET: "${XRAY_LOCATION_ASSET:-#{pkgshare}}"

    pkgshare.install resource("geoip")
    resource("geosite").stage do
      pkgshare.install "dlc.dat" => "geosite.dat"
    end
    pkgetc.install resource("example_config")
  end

  def caveats
    <<~EOS
      An example config is installed to #{etc}/xray/config.json
    EOS
  end

  service do
    run [opt_bin/"xray", "run", "--config", "#{etc}/xray/config.json"]
    run_type :immediate
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
    output = shell_output "#{bin}/xray -c #{testpath}/config.json -test"

    assert_match "Configuration OK", output
    assert_path_exists testpath/"log"
  end
end
