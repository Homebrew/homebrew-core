class Xray < Formula
  desc "Platform for building proxies to bypass network restrictions"
  homepage "https://xtls.github.io/"
  url "https://github.com/XTLS/Xray-core/archive/v1.4.2.tar.gz"
  sha256 "565255d8c67b254f403d498b9152fa7bc097d649c50cb318d278c2be644e92cc"
  license all_of: ["MPL-2.0", "CC-BY-SA-4.0"]
  revision 1
  head "https://github.com/XTLS/Xray-core.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "e7bd4ff6c49faa87d273c9cae05a46d4613e7718d192477e44ce34913f4b21a5"
    sha256 cellar: :any_skip_relocation, big_sur:       "e6045666df8f87a58ded259f67bfea7199eeca12cb0b29f8e697b1c71ae95123"
    sha256 cellar: :any_skip_relocation, catalina:      "c8e68f1c303bc7dcfd045fc7344183aaf79cf1a836c4781b7e60aacebe312d3c"
    sha256 cellar: :any_skip_relocation, mojave:        "1a45b3784597260e0659cd0ae2127edeffccf83c5051cecbda6f1b046ff034f1"
  end

  depends_on "go" => :build

  resource "geoip" do
    url "https://github.com/v2fly/geoip/releases/download/202104010913/geoip.dat"
    sha256 "f94e464f7f37e6f3c88c2aa5454ab02a4b840bc44c75c5001719a618916906cf"
  end

  resource "geosite" do
    url "https://github.com/v2fly/domain-list-community/releases/download/20210401091829/dlc.dat"
    sha256 "ee9778dc00b703905ca1f400ad13dd462eae52c5aee6465f0a7543b0232c9d08"
  end

  resource "example_config" do
    # borrow v2ray (v4.36.2) example config
    url "https://raw.githubusercontent.com/v2fly/v2ray-core/v4.36.2/release/config/config.json"
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
