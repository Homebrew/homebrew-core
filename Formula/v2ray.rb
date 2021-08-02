class V2ray < Formula
  desc "Platform for building proxies to bypass network restrictions"
  homepage "https://v2fly.org/"
  url "https://github.com/v2fly/v2ray-core/archive/v4.40.1.tar.gz"
  sha256 "75b599cb9866c2469056b71f2c0c69cbdab08cf15f6bd2273c893cd0bd16f175"
  license all_of: ["MIT", "CC-BY-SA-4.0"]
  head "https://github.com/v2fly/v2ray-core.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "aab16537aac1687d7ba359fa7ea3e178d629672805d9d9cb3bdb6f850a62e94b"
    sha256 cellar: :any_skip_relocation, big_sur:       "f7578b50924a4a106828878be8bbe152ea745322068e63863e855e5b65491593"
    sha256 cellar: :any_skip_relocation, catalina:      "3be2f3867d44219f779b869f2698d64b99e76b14feccf74a55b5434a244410bd"
    sha256 cellar: :any_skip_relocation, mojave:        "21edec4cbfec0cc8327f39fbb1fd95f8b1eb3db6acdc29c38bda421ebcfe9e02"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "26e9f61091546464b5ae08d301a679ee16f70e71595dc230a4e086d3aa0c0637"
  end

  depends_on "go" => :build

  resource "geoip" do
    url "https://github.com/v2fly/geoip/releases/download/202106170022/geoip.dat"
    sha256 "af7b0e6b92fa7b1d55b2b9d8155e9a2372b6b0be0e1b9e09353d9859680f6bb1"
  end

  resource "geosite" do
    url "https://github.com/v2fly/domain-list-community/releases/download/20210621183458/dlc.dat"
    sha256 "b78075874cb24c82fd2096e521452ff673fadb3d4d8048da73681f9b4722d0e2"
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
