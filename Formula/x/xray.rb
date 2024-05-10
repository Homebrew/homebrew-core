class Xray < Formula
  desc "Platform for building proxies to bypass network restrictions"
  homepage "https://xtls.github.io/"
  url "https://github.com/XTLS/Xray-core/archive/refs/tags/v1.8.11.tar.gz"
  sha256 "d99ee6008c508abbad6bbb242d058b22efb50fb35867d15447a2b4602ab4b283"
  license all_of: ["MPL-2.0", "CC-BY-SA-4.0"]
  head "https://github.com/XTLS/Xray-core.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0e6e727fdfbfb0a0938ad2e72587977ab46a74f77e6eebd605bc2cc9e87da033"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "01e0928f94cfc016973a04681ffa3fdbd12bd44d3af0d2dc0b16b341eb59ba1f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c4d0ba563763397dd5b5b9eabc6f709e2a3e176e013a4601921d4611e27d1b50"
    sha256 cellar: :any_skip_relocation, sonoma:         "a62643eb584395dcbf3dfa1afa40c60dceab13ec7724404fcd275a3ce893eb36"
    sha256 cellar: :any_skip_relocation, ventura:        "617c95fb576a333c972293383db8280f19fa19380351347aaf048ad2bb9bb161"
    sha256 cellar: :any_skip_relocation, monterey:       "405d0885716d3d531c018f40834bc10592190d31f13097d2e4ccd38204a37078"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "073fb48c5423a01eab59afe84d80db1dc17b2ddfa0f3881e6e13d5fa980875b6"
  end

  depends_on "go" => :build

  resource "geoip" do
    url "https://github.com/v2fly/geoip/releases/download/202404250042/geoip.dat"
    sha256 "8ad42be541dfa7c2e548ba94b6dcb3fe431a105ba14d3907299316a036723760"
  end

  resource "geosite" do
    url "https://github.com/v2fly/domain-list-community/releases/download/20240426060244/dlc.dat"
    sha256 "7aa19bb7fa5f99d62d3db87b632334caa356fb9b901f85f7168c064370973646"
  end

  resource "example_config" do
    # borrow v2ray example config
    url "https://raw.githubusercontent.com/v2fly/v2ray-core/v5.15.3/release/config/config.json"
    sha256 "1bbadc5e1dfaa49935005e8b478b3ca49c519b66d3a3aee0b099730d05589978"
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
