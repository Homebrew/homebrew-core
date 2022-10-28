class Xray < Formula
  desc "Platform for building proxies to bypass network restrictions"
  homepage "https://xtls.github.io/"
  url "https://github.com/XTLS/Xray-core/archive/refs/tags/v1.6.1.tar.gz"
  sha256 "8b4cc89d83b0ded75630119d9e2456764530490c7fb5e8a27de0cdf9c57fef15"
  license all_of: ["MPL-2.0", "CC-BY-SA-4.0"]
  head "https://github.com/XTLS/Xray-core.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7cade742dfd9dc926bcb666cd5320e9f145fdfb4c933aacc1bcddd27e1f4c280"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c94abc4d8b34e5f4c46d4c919411b374d6d8412ba72330db58ddc8bb7b147a9b"
    sha256 cellar: :any_skip_relocation, monterey:       "31e17210394de13d0795d59984ac0df5fef18333e1247f90dd1da13a199042cf"
    sha256 cellar: :any_skip_relocation, big_sur:        "be2db01049b400a4bd380fc8c74c04337502419b43d888c3f39f8ea6205e7321"
    sha256 cellar: :any_skip_relocation, catalina:       "56e38d443238f122e810507171b97e237d8ed672c7ba77386368c916b6f7bdf2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0207b0afda5586304d0d45c81e474a07bc8404ff2d0049d39635fe586b05f594"
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
