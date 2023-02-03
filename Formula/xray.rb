class Xray < Formula
  desc "Platform for building proxies to bypass network restrictions"
  homepage "https://xtls.github.io/"
  url "https://github.com/XTLS/Xray-core/archive/refs/tags/v1.7.3.tar.gz"
  sha256 "dcca9bd46813129325dd9128d34b096475668032f919677dbf5aaeea93b6694f"
  license all_of: ["MPL-2.0", "CC-BY-SA-4.0"]
  head "https://github.com/XTLS/Xray-core.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c6fce7a05d77c7736dcaa3daf6fdcd5f64aad1eceb8fbe05e14f6571d527acde"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "309dd24ab645763a02d42714864fab8ee90042c28c84c6257cdbb1a15b2f5432"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "be172e85b8f350fe7125303a4d9f0a94144b33aef0fe211297c09a4c44fddcfe"
    sha256 cellar: :any_skip_relocation, ventura:        "78e679664d47b76e291a642b09e4675b9d6daba0e81e4fe1958c9b3be9a0f904"
    sha256 cellar: :any_skip_relocation, monterey:       "e2627d8d2126d579eed339286d4fc24b387ec28e6ef6cee5bea53cb5d19fb84e"
    sha256 cellar: :any_skip_relocation, big_sur:        "33145bab99c36c39a1e690d59f251dbfe6a9aab2c55e2dcb448849fc4c69e0e4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3656e25764cf4e78484afb5044f4ed1e0f46c0ecebd34cfd958cd48e63f7d47d"
  end

  depends_on "go" => :build

  resource "geoip" do
    url "https://github.com/v2fly/geoip/releases/download/202212290044/geoip.dat"
    sha256 "da84c95fcc09bdb60334cf4ff0d26e6ff1c3d7906a9c5c91d69556a425558677"
  end

  resource "geosite" do
    url "https://github.com/v2fly/domain-list-community/releases/download/20221230094252/dlc.dat"
    sha256 "ed244308475f880a06a02ebd7872790bb32704ca3bdc7c79070aa35f496080e0"
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
