class Xray < Formula
  desc "Platform for building proxies to bypass network restrictions"
  homepage "https://xtls.github.io/"
  url "https://github.com/XTLS/Xray-core/archive/refs/tags/v1.5.3.tar.gz"
  sha256 "4b8d78cc20bdf2e8936c02b05d22f0a3231075155ffdc67508d8448ab8858252"
  license all_of: ["MPL-2.0", "CC-BY-SA-4.0"]
  head "https://github.com/XTLS/Xray-core.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b1d8494e7cd54a18c4959ed904e7209de1a9006f0862f2a1b217557ebd14aeea"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8ad6babecdbb110c00d55a647024837394e9711dc888541788611f79fdf41422"
    sha256 cellar: :any_skip_relocation, monterey:       "76dfb3a96c2034bac1c8de0e49c245bd9a07b5c35254074109aa5c58b0e64be1"
    sha256 cellar: :any_skip_relocation, big_sur:        "25fe9f1f34db71d927cef672032e2c6174083f69fa27c4120c1f80418bf726c0"
    sha256 cellar: :any_skip_relocation, catalina:       "0d8122a0554a461d2d5f534af6c740f1b0a65df27d87faa580c10961c4622e1f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bbc2bf826c89eacc4ab449d285e8b68550724bdd46bb2d6d9c04bd6baa395047"
  end

  depends_on "go" => :build

  resource "geoip" do
    url "https://github.com/v2fly/geoip/releases/download/202203170039/geoip.dat"
    sha256 "12c183defbc052e6bd96eb088a7f955f9d3a62d662009d5fb63da040e954e6c8"
  end

  resource "geosite" do
    url "https://github.com/v2fly/domain-list-community/releases/download/20220313173740/dlc.dat"
    sha256 "85ae4443a4192c0ff4c759e8a959dac02fac3628be62531939cc9059c3285ad0"
  end

  resource "example_config" do
    # borrow v2ray example config
    url "https://raw.githubusercontent.com/v2fly/v2ray-core/v4.44.0/release/config/config.json"
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
