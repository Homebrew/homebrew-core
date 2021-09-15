class Xray < Formula
  desc "Platform for building proxies to bypass network restrictions"
  homepage "https://xtls.github.io/"
  url "https://github.com/XTLS/Xray-core/archive/v1.4.3.tar.gz"
  sha256 "222c03855aa22cd47a648c63b8fa82d37b36983b5c99dc0e2f3c61a79edbb850"
  license all_of: ["MPL-2.0", "CC-BY-SA-4.0"]
  head "https://github.com/XTLS/Xray-core.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "43b04e6616684366cd64de19cfacc1cdc83f47379408429f429071ca93067b21"
    sha256 cellar: :any_skip_relocation, big_sur:       "3c9ed4fef4835eba3de1e2974c3fc8744bb831f71e3a3f12c557e47e987d2971"
    sha256 cellar: :any_skip_relocation, catalina:      "7fb5f23761affc9b9c9d7040a381d46879274eb0f05797b0d29ded09af49f932"
    sha256 cellar: :any_skip_relocation, mojave:        "85a69b6557a3109b28c2c24afd4e459922d54fa66c934c83e58fac4eb5c85a52"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ed8b487c81c23ab1213225aebac6ce0bdf30dad33ca5c9ea8a4cedeede33823c"
  end

  depends_on "go" => :build

  resource "geoip" do
    url "https://github.com/v2fly/geoip/releases/download/202109060310/geoip.dat"
    sha256 "ed94122961f358abede9f1954722039d5a0300b614c77cc27d92618c08b97bb8"
  end

  resource "geosite" do
    url "https://github.com/v2fly/domain-list-community/releases/download/20210906031055/dlc.dat"
    sha256 "7618b876fd5a1066d0b44c1c8ce04608495ae991806890f8b1cbfafe79caf6c1"
  end

  resource "example_config" do
    # borrow v2ray (v4.36.2) example config
    url "https://raw.githubusercontent.com/v2fly/v2ray-core/v4.41.1/release/config/config.json"
    sha256 "1bbadc5e1dfaa49935005e8b478b3ca49c519b66d3a3aee0b099730d05589978"
  end

  def install
    ldflags = "-s -w -buildid="
    execpath = libexec/name
    system "go", "build", *std_go_args, "-o", execpath,
                 "-ldflags", ldflags,
                 "./main"
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
