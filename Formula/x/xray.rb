class Xray < Formula
  desc "Platform for building proxies to bypass network restrictions"
  homepage "https://xtls.github.io/"
  url "https://github.com/XTLS/Xray-core/archive/refs/tags/v25.10.15.tar.gz"
  sha256 "5df030f456db58b682110545e19da9b971303387955562ec408f484580450736"
  license all_of: ["MPL-2.0", "CC-BY-SA-4.0"]
  head "https://github.com/XTLS/Xray-core.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "37dd6170eaac307d4a2497ac0e9c0d89f5a1be09a7b520fe22c094972ece8a92"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "37dd6170eaac307d4a2497ac0e9c0d89f5a1be09a7b520fe22c094972ece8a92"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "37dd6170eaac307d4a2497ac0e9c0d89f5a1be09a7b520fe22c094972ece8a92"
    sha256 cellar: :any_skip_relocation, sonoma:        "6787776cb6deb987d7d7613682deb7baf65a959eeec4dbeb4dbcf70b2c58bc72"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d343d6a400127221f4c0b53d5ac5eb7366d2eea263dff056bc564ad850bf78c3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4d518053d707c0dbac24a937d0de3cca85e800a0fc5b173872254ad8c2bb9cfb"
  end

  depends_on "go" => :build

  resource "geoip" do
    url "https://github.com/v2fly/geoip/releases/download/202510050144/geoip.dat"
    sha256 "c23ac8343e9796f8cc8b670c3aeb6df6d03d4e8914437a409961477f6b226098"
  end

  resource "geosite" do
    url "https://github.com/v2fly/domain-list-community/releases/download/20250916122507/dlc.dat"
    sha256 "1a7dad0ceaaf1f6d12fef585576789699bd1c6ea014c887c04b94cb9609350e9"
  end

  resource "example_config" do
    # borrow v2ray example config
    url "https://raw.githubusercontent.com/v2fly/v2ray-core/v5.40.0/release/config/config.json"
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
