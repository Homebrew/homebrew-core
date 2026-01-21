class Xray < Formula
  desc "Platform for building proxies to bypass network restrictions"
  homepage "https://xtls.github.io/"
  url "https://github.com/XTLS/Xray-core/archive/refs/tags/v26.1.18.tar.gz"
  sha256 "1a5f6e23997b45eb096b905d41fd2ab026063e7889d38c69694f2be69a74d712"
  license all_of: ["MPL-2.0", "CC-BY-SA-4.0"]
  head "https://github.com/XTLS/Xray-core.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "46b1a513371a2e9d2e7abc20ba3760f35ff59227d3b94e4d9291719c14401601"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "46b1a513371a2e9d2e7abc20ba3760f35ff59227d3b94e4d9291719c14401601"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "46b1a513371a2e9d2e7abc20ba3760f35ff59227d3b94e4d9291719c14401601"
    sha256 cellar: :any_skip_relocation, sonoma:        "8bec5be95c8f8a76c8e922fb9a5160842676ce676310faaead8897b26b9dc5f2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "92683a89767c9a401b2900a98723d27bf1aa82958dfd279a5636ddf94550b4f3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5c0050811c294f2a04dfc1ae77110785f691afc1b8f8ff445b8406eca9d7408f"
  end

  depends_on "go" => :build

  resource "geoip" do
    url "https://github.com/v2fly/geoip/releases/download/202601050204/geoip.dat"
    sha256 "ed2de9add79623e2e5dbc5930ee39cc7037a7c6e0ecd58ba528b6f73d61457b5"
  end

  resource "geosite" do
    url "https://github.com/v2fly/domain-list-community/releases/download/20260117053629/dlc.dat"
    sha256 "b8ae0a67f1abff87fcdef3ae4439984075a7ba6af667fa6d8b5bfe316ccf65c5"
  end

  resource "example_config" do
    # borrow v2ray example config
    url "https://raw.githubusercontent.com/v2fly/v2ray-core/v5.42.0/release/config/config.json"
    sha256 "15a66415d72df4cd77fcd037121f36604db244dcfa7d45d82a0c33de065c6a87"

    livecheck do
      url "https://github.com/v2fly/v2ray-core.git"
    end
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
    (testpath/"config.json").write <<~JSON
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
    JSON
    output = shell_output "#{bin}/xray -c #{testpath}/config.json -test"

    assert_match "Configuration OK", output
    assert_path_exists testpath/"log"
  end
end
