class Xray < Formula
  desc "Platform for building proxies to bypass network restrictions"
  homepage "https://xtls.github.io/"
  url "https://github.com/XTLS/Xray-core/archive/refs/tags/v1.6.0.tar.gz"
  sha256 "b65375090a2d48d358a582837d485bfaa9572e4d1f5a649895b9fd83d0f69e43"
  license all_of: ["MPL-2.0", "CC-BY-SA-4.0"]
  head "https://github.com/XTLS/Xray-core.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "beb209215b52e25ef11122706e17cec5bc7099f41d5f9b3a460028973b90ef83"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d42201b98ee667c35765e1fa3ec0c49ae448e6a49c2d26524ec550abb05468ba"
    sha256 cellar: :any_skip_relocation, monterey:       "178c6ac6be354802fb9e0af1c4825c16146f544892150919a701a11c45947226"
    sha256 cellar: :any_skip_relocation, big_sur:        "f2f964525de6bceca5dae8ea03e9d7585c7e65f87e6d18de5db15031f730def7"
    sha256 cellar: :any_skip_relocation, catalina:       "a421fca6fd3715289ca709bf8755fb93caa245e3836dad54336da4b84593629d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "867a1c2cdba407f8e7cea1396183ede377c0e0f1181b1b4fb1e71ec03e937bbf"
  end

  depends_on "go" => :build

  resource "geoip" do
    url "https://github.com/v2fly/geoip/releases/download/202209220104/geoip.dat"
    sha256 "20f6ceaa1e39a9de5473d94979855fe3eb93a5ba4a272862a58d59c7bd4ae908"
  end

  resource "geosite" do
    url "https://github.com/v2fly/domain-list-community/releases/download/20220922071547/dlc.dat"
    sha256 "9aa0144d9e2a6242cbd2b23bdbf433b3f5e02b4ff4afe2cf208a10a99ab00553"
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
