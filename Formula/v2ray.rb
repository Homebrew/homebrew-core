class V2ray < Formula
  desc "Platform for building proxies to bypass network restrictions"
  homepage "https://v2fly.org/"
  url "https://github.com/v2fly/v2ray-core/archive/v4.33.0.tar.gz"
  sha256 "ce456df0a798e1ed76ec014cb619e89c508bfb812c689260067575ee94e18c76"
  license all_of: ["MIT", "CC-BY-SA-4.0"]
  head "https://github.com/v2fly/v2ray-core.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "7b6b61b6bd3488132f35852356c22b04d19e79bc97e93b7778daf717a8a8fcc2" => :big_sur
    sha256 "09066d9a293fc5d9759a6c5f9325632d213dbb6c72cfa465d5f1f4da10164850" => :catalina
    sha256 "352ebff222463c09df705673743ed8699ad202ddcc17154e9fb27906bfb788dd" => :mojave
  end

  depends_on "go" => :build

  resource "geoip" do
    url "https://github.com/v2fly/geoip/releases/download/202011190012/geoip.dat"
    sha256 "022e6426f66cd7093fc2454c28537d2345b4fce49dc97b81ddfec07ce54e7081"
  end

  resource "geosite" do
    url "https://github.com/v2fly/domain-list-community/releases/download/20201122065644/dlc.dat"
    sha256 "574af5247bb83db844be03038c8fed1e488bf4bd4ce5de2843847cf40be923c1"
  end

  def install
    ldflags = "-s -w -buildid="
    system "go", "build", *std_go_args,
                 "-ldflags", ldflags,
                 "./main"
    system "go", "build", *std_go_args,
                 "-ldflags", ldflags,
                 "-tags", "confonly",
                 "-o", bin/"v2ctl",
                 "./infra/control/main"

    pkgetc.install "release/config/config.json" => "config.json"

    resource("geoip").stage do
      pkgshare.install "geoip.dat"
    end

    resource("geosite").stage do
      pkgshare.install "dlc.dat" => "geosite.dat"
    end
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
