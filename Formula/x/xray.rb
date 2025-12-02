class Xray < Formula
  desc "Platform for building proxies to bypass network restrictions"
  homepage "https://xtls.github.io/"
  url "https://github.com/XTLS/Xray-core/archive/refs/tags/v25.12.1.tar.gz"
  sha256 "f1ab22b87e9e446d5e96cb00a8593b85826cc8a1bbc960e0eb0081293d6a32ab"
  license all_of: ["MPL-2.0", "CC-BY-SA-4.0"]
  head "https://github.com/XTLS/Xray-core.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0ddb1c9a9d1a39a9f51d6bc15942c952747d9d8130ce95c05459b556050b2733"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0ddb1c9a9d1a39a9f51d6bc15942c952747d9d8130ce95c05459b556050b2733"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0ddb1c9a9d1a39a9f51d6bc15942c952747d9d8130ce95c05459b556050b2733"
    sha256 cellar: :any_skip_relocation, sonoma:        "3b6dcb4de9620f8dafe605c4aeb172eba9ed78524a6fabb53981be75b306b3fb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3a47d74a21eeba3acf13583abebb7046cb568c1b38810efb203c7b3251508e9f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d0d46ef1c318564d6caefd912665a4de7ca521251c7d2964b8667d6c0b09caf5"
  end

  depends_on "go" => :build

  resource "geoip" do
    url "https://github.com/v2fly/geoip/releases/download/202511210201/geoip.dat"
    sha256 "2445b44d9ae3ab9a867c9d1e0e244646c4c378622e14b9afaf3658ecf46a40b9"
  end

  resource "geosite" do
    url "https://github.com/v2fly/domain-list-community/releases/download/20251201150926/dlc.dat"
    sha256 "868d244cdc8e55166c372bdcfef4ef73c45c77eb96420bf684af658fc34475b7"
  end

  resource "example_config" do
    # borrow v2ray example config
    url "https://raw.githubusercontent.com/v2fly/v2ray-core/v5.41.0/release/config/config.json"
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
