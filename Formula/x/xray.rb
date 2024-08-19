class Xray < Formula
  desc "Platform for building proxies to bypass network restrictions"
  homepage "https://xtls.github.io/"
  url "https://github.com/XTLS/Xray-core/archive/refs/tags/v1.8.23.tar.gz"
  sha256 "c3731f11efae32296be75774cb4e86667fbc6e685cae4a891a0bc567b839ac7f"
  license all_of: ["MPL-2.0", "CC-BY-SA-4.0"]
  head "https://github.com/XTLS/Xray-core.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bc681a1e30f1afd996746e3c5f8ea209a8b110de183b436310cb50ebb225344f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "610d1438983b546a607d756cb955b439e356e4b86070a460583b85e78c3f24b4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "160cc7ebfefa74cbb3b3113a2ad0810c2913822bccc2c0c6deb574197c0271fd"
    sha256 cellar: :any_skip_relocation, sonoma:         "cfb834e09998760907a8bba884084f96ae2be751803bb5dd4d6b1881ef0d0f60"
    sha256 cellar: :any_skip_relocation, ventura:        "ed07903e7794b79779e33b6d88c2af8b5fbe284d3e8731cd9331dea660db12fa"
    sha256 cellar: :any_skip_relocation, monterey:       "5323c0adadf357579f32c4d2b7536866d92b5febfdc7409deae68af53e3ef662"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a32453e5622ad1bf0eef7c1b81b3b24711710983b920133c0fd7805f26d3e8d0"
  end

  depends_on "go" => :build

  resource "geoip" do
    url "https://github.com/v2fly/geoip/releases/download/202407250045/geoip.dat"
    sha256 "f83e89edfd3b35acbbbb862a4c88a8ca3e1ddce4d298cc617be79bdaa23a0672"
  end

  resource "geosite" do
    url "https://github.com/v2fly/domain-list-community/releases/download/20240726161926/dlc.dat"
    sha256 "f329656f27a1dac1971e1dff9aed2d7a60029d087e1216b2536c1e86ebe82ca3"
  end

  resource "example_config" do
    # borrow v2ray example config
    url "https://raw.githubusercontent.com/v2fly/v2ray-core/v5.16.1/release/config/config.json"
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
