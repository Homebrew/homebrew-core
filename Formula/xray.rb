class Xray < Formula
  desc "Platform for building proxies to bypass network restrictions"
  homepage "https://xtls.github.io/"
  url "https://github.com/XTLS/Xray-core/archive/refs/tags/v1.5.4.tar.gz"
  sha256 "af9b9b5b0a2d4f055d19f3580d1c2d3141bbaab9dd7824428c12ae0ced5f511e"
  license all_of: ["MPL-2.0", "CC-BY-SA-4.0"]
  head "https://github.com/XTLS/Xray-core.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "736a8fa5373f4606982e3c951f774b4b9ef65b0186df996cc73e189f669fc177"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "dbfd8c378b46d787072b693d7d5a8c07ada5d46b20dcae22e3f6fe811c2dfa9f"
    sha256 cellar: :any_skip_relocation, monterey:       "d42b2abf4a0400df6119c7d81aae3038532dc072ded2c4dfc8e009bc3c8e7fcf"
    sha256 cellar: :any_skip_relocation, big_sur:        "bafd761249640347a61652f793af75cf3b745dcc6be857a593852eae079235fc"
    sha256 cellar: :any_skip_relocation, catalina:       "7ed391b74a3b3f7f1d45a142fe874c753ec1b64e3c057e1a6aabac588a5b7893"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fe76211ca46c7d3d07de32c00d73e2f4afcbb5ca3666f887f89f0bf2abf5d1f9"
  end

  depends_on "go" => :build

  resource "geoip" do
    url "https://github.com/v2fly/geoip/releases/download/202203170039/geoip.dat"
    sha256 "12c183defbc052e6bd96eb088a7f955f9d3a62d662009d5fb63da040e954e6c8"
  end

  resource "geosite" do
    url "https://github.com/v2fly/domain-list-community/releases/download/20220320055819/dlc.dat"
    sha256 "644c20f0df438b618c4200370b21c27885699d73af9cd781dfb21a922317cef8"
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
