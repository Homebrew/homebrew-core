class Zrok < Formula
  desc "Geo-scale, next-generation sharing platform built on top of OpenZiti"
  homepage "https://zrok.io"
  url "https://github.com/openziti/zrok/releases/download/v1.1.10/source-v1.1.10.tar.gz"
  sha256 "1e6999f11be37fab066254d080a3593e37835a2f8d7927d13e8524acf5e6073d"
  # The main license is Apache-2.0. ACKNOWLEDGEMENTS.md lists licenses for parts of code
  license all_of: ["Apache-2.0", "BSD-3-Clause", "MIT"]
  head "https://github.com/openziti/zrok.git", branch: "main"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f119049ac0ea153167191c0ee9da00a052ee1e7a523fb609820e123f96696e27"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "999818d3fa25c30120a5db6ba5a8dd7ce152593ca017bbf59f18cc7c35b2b1f7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "af66c3978664de1a290fc71ab5767e48a7caa81376dd59bd7c690593be4c9e72"
    sha256 cellar: :any_skip_relocation, sonoma:        "fd805e9a12731fefad3b83875236d3c22d2c1fbe8a4c52eed42ba9b35fe48d98"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "06dd4b43ca1833265863cb58066e3390b7807197df83142fe65bb88cf38f871e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0b0c4c54227362d9b43651e76eb09b287fac2106eeece701a6656ca7e7a8fbf5"
  end

  depends_on "go" => :build
  depends_on "node" => :build

  def install
    ["ui", "agent/agentUi"].each do |ui_dir|
      cd "#{buildpath}/#{ui_dir}" do
        system "npm", "install", *std_npm_args(prefix: false)
        system "npm", "run", "build"
      end
    end

    # Workaround to avoid patchelf corruption when cgo is required (for go-sqlite3)
    if OS.linux? && Hardware::CPU.arch == :arm64
      ENV["CGO_ENABLED"] = "1"
      ENV["GO_EXTLINK_ENABLED"] = "1"
      ENV.append "GOFLAGS", "-buildmode=pie"
    end

    ldflags = %W[
      -s -w
      -X github.com/openziti/zrok/build.Version=v#{version}
      -X github.com/openziti/zrok/build.Hash=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/zrok"
  end

  test do
    (testpath/"ctrl.yml").write <<~YAML
      v: 4
      maintenance:
        registration:
          expiration_timeout:           24h
          check_frequency:              1h
          batch_limit:                  500
        reset_password:
          expiration_timeout:           15m
          check_frequency:              15m
          batch_limit:                  500
    YAML

    version_output = shell_output("#{bin}/zrok version")
    assert_match(/\bv#{version}\b/, version_output)
    assert_match(/[[a-f0-9]{40}]/, version_output)

    status_output = shell_output("#{bin}/zrok controller validate #{testpath}/ctrl.yml 2>&1")
    assert_match("expiration_timeout = 24h0m0s", status_output)
  end
end
