class Xray < Formula
  desc "Platform for building proxies to bypass network restrictions"
  homepage "https://xtls.github.io/"
  url "https://github.com/XTLS/Xray-core/archive/refs/tags/v1.8.6.tar.gz"
  sha256 "d828296c9f29f9e59a61ab73d44f072ab2a30fe979679e39aea43b33ddb7d6bf"
  license all_of: ["MPL-2.0", "CC-BY-SA-4.0"]
  head "https://github.com/XTLS/Xray-core.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "067ca1d7c4c56340daedd7cc0a05c266f7ff5c25051327d039d3adf17d3f47b9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a64e8beb3b11d4940e9add0c300808f15724687cb5748d74b5555c4bbcc1ba70"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "12d3b6ee47cdc55d08b4fa9d00f4311242302c360fd81787fc6c53640567df30"
    sha256 cellar: :any_skip_relocation, sonoma:         "1304e8695d57415c3bfedd9c453cc1fb56779eb24957621b5a757fe6227c4b73"
    sha256 cellar: :any_skip_relocation, ventura:        "4997b512ef5cf0c1d8c9ee9097a1bd1e94dfc99e0296b69a41fe943450a1eed9"
    sha256 cellar: :any_skip_relocation, monterey:       "5f48c67aaef77b31792dc66d12c96ab82bb2ac9ca5b84d7e8a2883cccbc94233"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a57347c5ed836f10707118c0b5ab39f5e54d7e83ad528e5355770791982cab5c"
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
