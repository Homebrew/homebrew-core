class V2ray < Formula
  desc "Platform for building proxies to bypass network restrictions"
  homepage "https://v2fly.org/"
  url "https://github.com/v2fly/v2ray-core/archive/v4.44.0.tar.gz"
  sha256 "d9973bafd3020f60a51fa3495b24ab417b08b3c8f9539a3748d00da6c68d0103"
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
    url "https://github.com/v2fly/geoip/releases/download/202112060252/geoip.dat"
    sha256 "7cc3d27ae1c59062148d4968f8d98eff9038212111e0bb129f46831198a0750b"
  end

  resource "geoip-only-cn-private" do
    url "https://github.com/v2fly/geoip/releases/download/202112060252/geoip-only-cn-private.dat"
    sha256 "d5d9fbfbe489a6acd2cc215eb699b95ff16801e12b4ba6af3e0a64e3f530d9e7"
  end

  resource "geosite" do
    url "https://github.com/v2fly/domain-list-community/releases/download/20211203092402/dlc.dat"
    sha256 "d39a595800d57b8fcfa5924db69b9ab3f1f798cbdaf449afcac78d377ca1c501"
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
