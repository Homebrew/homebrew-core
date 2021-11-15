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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c38f3efb9ae992800d3782c2e89f1f48fd9ae273566a9b0b131fe91a7e04958f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5f2e213e1f2dbcd8bc8d8101f452d12b4d16eba09bb9cbafae7cec44754579d3"
    sha256 cellar: :any_skip_relocation, monterey:       "ca0c95d4607730d9a7461c3561045c4976fd0f6bff05b1294b3cd7a19b563973"
    sha256 cellar: :any_skip_relocation, big_sur:        "f33265071c5573d0c129ec320dd225805518083feadab6561acedbc06045aa47"
    sha256 cellar: :any_skip_relocation, catalina:       "b6b2e1efcbaf69ecc084b0f6856f770a05c69d4f651c37a505b8f34fb69c3c4e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "86453bcba9ac3b90ed862c158a5cfe17138ade209a3fd9965e8650b0d40d9078"
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
