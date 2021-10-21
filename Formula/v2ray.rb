class V2ray < Formula
  desc "Platform for building proxies to bypass network restrictions"
  homepage "https://v2fly.org/"
  url "https://github.com/v2fly/v2ray-core/archive/v4.43.0.tar.gz"
  sha256 "f27b8fe8e1e102b0297339ee368c8b650fde0f949e0d90e1229ff6744f99ba0f"
  license all_of: ["MIT", "CC-BY-SA-4.0"]
  head "https://github.com/v2fly/v2ray-core.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "58a341d97e01eade50de245608cf61069b372917e447c6fc5d478e38d76af786"
    sha256 cellar: :any_skip_relocation, big_sur:       "58880e010e81991c51c3f1bf9347fab816a556b370481b048f28789c56e32b1d"
    sha256 cellar: :any_skip_relocation, catalina:      "a6e0a954b4cec4600212e706d56bda7ae8d5b89467bacb5f73ee3f320a0fee5e"
    sha256 cellar: :any_skip_relocation, mojave:        "7fbf1fc09f1b7ab1c6952c3d2a3e3042d36920c22558d7a42b5c2f6f06d27380"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "19fe8081c43b3b2b2419310a5966c6d016e2aaf7e42fc29af58b5b5ef6ff5259"
  end

  depends_on "go" => :build

  resource "geoip" do
    url "https://github.com/v2fly/geoip/releases/download/202110210032/geoip.dat"
    sha256 "932cd484471f8066c040ab84a04fdd70df6c5cee99545de610e1f337bb696220"
  end

  resource "geoip-only-cn-private" do
    url "https://github.com/v2fly/geoip/releases/download/202110210032/geoip-only-cn-private.dat"
    sha256 "d159020b5fcd4b24668e5a8d7adfbb8b04ee314729c3a7f054696901568731a4"
  end

  resource "geosite" do
    url "https://github.com/v2fly/domain-list-community/releases/download/20211018134657/dlc.dat"
    sha256 "60b2388b11f1f9b6e14794fbacdf3bf693e3101e3ec651ce5423d8caceda5497"
  end

  def install
    ldflags = "-s -w -buildid="
    execpath = libexec/name
    system "go", "build", *std_go_args, "-o", execpath,
                 "-ldflags", ldflags,
                 "./main"
    system "go", "build", *std_go_args,
                 "-ldflags", ldflags,
                 "-tags", "confonly",
                 "-o", bin/"v2ctl",
                 "./infra/control/main"
    (bin/"v2ray").write_env_script execpath,
      V2RAY_LOCATION_ASSET: "${V2RAY_LOCATION_ASSET:-#{pkgshare}}"

    pkgetc.install "release/config/config.json"

    resource("geoip").stage do
      pkgshare.install "geoip.dat"
    end

    resource("geoip-only-cn-private").stage do
      pkgshare.install "geoip-only-cn-private.dat"
    end

    resource("geosite").stage do
      pkgshare.install "dlc.dat" => "geosite.dat"
    end
  end

  service do
    run [bin/"v2ray", "-config", etc/"v2ray/config.json"]
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
    output = shell_output "#{bin}/v2ray -c #{testpath}/config.json -test"

    assert_match "Configuration OK", output
    assert_predicate testpath/"log", :exist?
  end
end
