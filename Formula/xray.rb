class Xray < Formula
  desc "Platform for building proxies to bypass network restrictions"
  homepage "https://xtls.github.io/"
  url "https://github.com/XTLS/Xray-core/archive/v1.5.0.tar.gz"
  sha256 "43f35c83902db9d1eba0210c0e27b7814d4caf198cd0424c8af9c97a3ce9a860"
  license all_of: ["MPL-2.0", "CC-BY-SA-4.0"]
  head "https://github.com/XTLS/Xray-core.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "ea9626bccd0b70aac0880d33f1d34bac66285f529d16d51e78e68b504fe1f76c"
    sha256 cellar: :any_skip_relocation, big_sur:       "5347284834dfeda1150dfae1831341be14f12cfd983641da9bd6b49488fd4053"
    sha256 cellar: :any_skip_relocation, catalina:      "42ed8b7eb67b83f0b560363f3a61ee0b3e7a698cb697df08e9a06453a9db4c74"
    sha256 cellar: :any_skip_relocation, mojave:        "47d081dfe999470fbbb7b1b64ce18c0fad7362be4b68d696db87a571c71f540d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3fc53062e26cc87199a676071958fc5f458baae4c68530c7f9315f988d7ed599"
  end

  depends_on "go" => :build

  resource "geoip" do
    url "https://github.com/v2fly/geoip/releases/download/202110140026/geoip.dat"
    sha256 "88cf4aca8a7d1494d7ced04b05bd2eadff814a3b9e3f521ea9269c68b06ffb00"
  end

  resource "geosite" do
    url "https://github.com/v2fly/domain-list-community/releases/download/20211018134657/dlc.dat"
    sha256 "60b2388b11f1f9b6e14794fbacdf3bf693e3101e3ec651ce5423d8caceda5497"
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
