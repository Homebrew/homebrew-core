class Xray < Formula
  desc "Platform for building proxies to bypass network restrictions"
  homepage "https://xtls.github.io/"
  url "https://github.com/XTLS/Xray-core/archive/refs/tags/v1.8.4.tar.gz"
  sha256 "89f73107abba9bd438111edfe921603ddb3c2b631b2716fbdc6be78552f0d322"
  license all_of: ["MPL-2.0", "CC-BY-SA-4.0"]
  head "https://github.com/XTLS/Xray-core.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "88c6074eeafa8f89e58c51bbd7325faaab9bce2003e6856958bb33f0ed570fc3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4b6a3e15ea99c4ac4701d3ea08c3681325c11572f3dd7f8039ea8c0b9ddf7d27"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4d7d5700cd773731f28f11ed293ee53e1cfa694f72290ae1dad86508f01af94d"
    sha256 cellar: :any_skip_relocation, ventura:        "ff889d4a2cdc1b94111ce29437236ee1b3621897ee963922b34d5fb19c5bfe95"
    sha256 cellar: :any_skip_relocation, monterey:       "188d740801ee78460ddc0f6fe17f067b8c9c5b15bd03866a757bb160907ea6ed"
    sha256 cellar: :any_skip_relocation, big_sur:        "0237fb0565cb82e311288d24f149731ffb9e8e2fd9fbdb238ea05e7c967eccb9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "48e5ec5166a75795baa3ae51bcf6d94eec65f3585cd2214b2c0b7c79b28e477c"
  end

  depends_on "go" => :build

  resource "geoip" do
    url "https://github.com/v2fly/geoip/releases/download/202308310037/geoip.dat"
    sha256 "536d7aa9f54af747153d4f982adaa3181025dd72faaba8f532b3f514b467eff8"
  end

  resource "geosite" do
    url "https://github.com/v2fly/domain-list-community/releases/download/20230825070717/dlc.dat"
    sha256 "231a6fb4915f7652ad9b2027965fbbb27435ffa9b3a0734ad2b69693e95d6604"
  end

  resource "example_config" do
    # borrow v2ray example config
    url "https://raw.githubusercontent.com/v2fly/v2ray-core/v4.45.2/release/config/config.json"
    sha256 "1bbadc5e1dfaa49935005e8b478b3ca49c519b66d3a3aee0b099730d05589978"
  end

  def install
    ldflags = "-s -w -buildid="
    execpath = libexec/name
    system "go", "build", *std_go_args(output: execpath, ldflags: ldflags), "./main"
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
    output = shell_output "#{bin}/xray -c #{testpath}/config.json -test"

    assert_match "Configuration OK", output
    assert_predicate testpath/"log", :exist?
  end
end
