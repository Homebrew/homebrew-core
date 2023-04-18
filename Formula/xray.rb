class Xray < Formula
  desc "Platform for building proxies to bypass network restrictions"
  homepage "https://xtls.github.io/"
  url "https://github.com/XTLS/Xray-core/archive/refs/tags/v1.7.5.tar.gz"
  sha256 "a5fc936136a57a463bf9a895d068fdfa895b168ae6093c58a10208e098b6b2d3"
  license all_of: ["MPL-2.0", "CC-BY-SA-4.0"]
  head "https://github.com/XTLS/Xray-core.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "02a0def74264e8b6308697d83cd59b2091994d212744c956a54eecad23d67673"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "02a0def74264e8b6308697d83cd59b2091994d212744c956a54eecad23d67673"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "02a0def74264e8b6308697d83cd59b2091994d212744c956a54eecad23d67673"
    sha256 cellar: :any_skip_relocation, ventura:        "173fd8e1c080f4863376842cfb8fb978dc18883242c8434627380fbc1a6f6801"
    sha256 cellar: :any_skip_relocation, monterey:       "173fd8e1c080f4863376842cfb8fb978dc18883242c8434627380fbc1a6f6801"
    sha256 cellar: :any_skip_relocation, big_sur:        "173fd8e1c080f4863376842cfb8fb978dc18883242c8434627380fbc1a6f6801"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9de81685475b5e01cdb209d2f0a22fbb50a57cdd2082f993c50d28a32dc0e685"
  end

  depends_on "go" => :build

  resource "geoip" do
    url "https://github.com/v2fly/geoip/releases/download/202302020047/geoip.dat"
    sha256 "33e7836477c4b8cf4fb547b74543ab373c6f0ab99d6f1eb62faec096042e901d"
  end

  resource "geosite" do
    url "https://github.com/v2fly/domain-list-community/releases/download/20230202101858/dlc.dat"
    sha256 "64ab40c10fd5f36d2b5746c4c16b657dba536cb749d6357a39fab2c3ab4bad31"
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
