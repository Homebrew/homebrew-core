class Xray < Formula
  desc "Platform for building proxies to bypass network restrictions"
  homepage "https://xtls.github.io/"
  url "https://github.com/XTLS/Xray-core/archive/refs/tags/v1.8.7.tar.gz"
  sha256 "e8f46177d792b89700f164ca28fbf1a3c7d95a3ecf98871cb0dd5e474b46a859"
  license all_of: ["MPL-2.0", "CC-BY-SA-4.0"]
  head "https://github.com/XTLS/Xray-core.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "66bc5138921547f67e17f684395d29cf4a425c22298ffc28ca0edf7e6c53619b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9646ad1481f14224f51e6dee29e7d0e96c0ea0cc356808fce511aecd5d1098fc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "16d18384d79f3972f3248fcad4000619c78c0ef9eeaefacaf2ea62cc01d88fae"
    sha256 cellar: :any_skip_relocation, sonoma:         "fb63d5fe664c4dbc4092348c853da6ede1e184636423b337c67aeae259c3cd87"
    sha256 cellar: :any_skip_relocation, ventura:        "d73bbad2cb301207eaf6e658bb4b895adacb26cb7c25e83b568bd5ff96d1aa63"
    sha256 cellar: :any_skip_relocation, monterey:       "79265f9441aca86a74e3ba5d2c017a8a4dc4aec5a98c3cf0048c18edc52becae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ec67a2af7e0b380ef9d1d760fac440b90ddc02d3ae990f163037726425f38146"
  end

  depends_on "go" => :build

  resource "geoip" do
    url "https://github.com/v2fly/geoip/releases/download/202401110041/geoip.dat"
    sha256 "37ec29d3aec3d22a575da7d6e858e22a492eafb8abc34a0b288d353acf6ee1a2"
  end

  resource "geosite" do
    url "https://github.com/v2fly/domain-list-community/releases/download/20240105034708/dlc.dat"
    sha256 "9f833c47b103fb475a68d3b0f5db99d7b7c31dd9deab9171781420db10751641"
  end

  resource "example_config" do
    # borrow v2ray example config
    url "https://raw.githubusercontent.com/v2fly/v2ray-core/v5.13.0/release/config/config.json"
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
