class Xray < Formula
  desc "Platform for building proxies to bypass network restrictions"
  homepage "https://xtls.github.io/"
  url "https://github.com/XTLS/Xray-core/archive/refs/tags/v26.11.9.tar.gz"
  sha256 "d5a47bed1b85e1cdfe3cb2f88a02e2db7144f0f8bee541d20b84fafa8fdf6c8d"
  license all_of: ["MPL-2.0", "CC-BY-SA-4.0"]
  head "https://github.com/XTLS/Xray-core.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "272647a033e73191c5b876c4fb5a4ebf0757609ab710f086d0c38b533f2c3344"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "272647a033e73191c5b876c4fb5a4ebf0757609ab710f086d0c38b533f2c3344"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "272647a033e73191c5b876c4fb5a4ebf0757609ab710f086d0c38b533f2c3344"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "bc5d4d8a39a119ff73abe726be825d931259d35eadcd415076ba6932ac9669df"
    sha256 cellar: :any,                 x86_64_linux:      "826c179ccf8812c647c7344f6fbeeace3af0a06fd780e0c94c00c0fff15fb89d"
  end

  depends_on "go" => :build

  resource "geoip" do
    url "https://github.com/XTLS/Xray-rules-dat/releases/download/20261108215333/geoip-lite.dat"
    version "20261108215333"
    sha256 "283119b5c7679d3cc9a750e1b6da693ecfd42e5d5036b57f0c2d0505f76e36f4"

    livecheck do
      url :url
    end
  end

  resource "geosite" do
    url "https://github.com/XTLS/Xray-rules-dat/releases/download/20261108215333/geosite.dat"
    version "20261108215333"
    sha256 "daaae9760ab5e687845817967257a6e9883d42ac9c09f4b774a32bd5cb39b4d7"

    livecheck do
      url :url
    end
  end

  resource "example_config" do
    # borrow v2ray example config
    url "https://raw.githubusercontent.com/v2fly/v2ray-core/v5.56.0/release/config/config.json"
    sha256 "15a66415d72df4cd77fcd037121f36604db244dcfa7d45d82a0c33de065c6a87"

    livecheck do
      url "https://github.com/v2fly/v2ray-core.git"
    end
  end

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    execpath = libexec/name
    system "go", "build", *std_go_args(output: execpath, ldflags: "-buildid="), "./main"
    (bin/"xray").write_env_script execpath,
      XRAY_LOCATION_ASSET: "${XRAY_LOCATION_ASSET:-#{pkgshare}}"

    resource("geoip").stage do
      pkgshare.install "geoip-lite.dat" => "geoip.dat"
    end
    resource("geosite").stage do
      pkgshare.install "geosite.dat"
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
