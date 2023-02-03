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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b739ca531f21a4dd6aee19c8e95d2b65ab023206c10c7bed08587b53550c6976"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "988dd07808358425bc111320696c773f82e60f0d62105d3b5be82ad0f17e877f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6369fe53f43a55ad72a23c77dc0a325e5e526aa3500cc1f8ae793e4eb4f7cb34"
    sha256 cellar: :any_skip_relocation, ventura:        "05aab5823412592f174489503a805291d4569633b005f585ce27b6ba8d2abf3f"
    sha256 cellar: :any_skip_relocation, monterey:       "337bc3483f22cf26c6d5c3c8e9e0eba378e0f2f705058468bf347c270f42365a"
    sha256 cellar: :any_skip_relocation, big_sur:        "bafa102cb282bf9c787352c3f12d4fe977f9e003cc4cb48af682a4a3586dff72"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "99e25615756c8e37ae8543a667203f4b568399c81e83f61bb3caaa9be7df5337"
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
