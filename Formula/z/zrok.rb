class Zrok < Formula
  desc "Geo-scale, next-generation sharing platform built on top of OpenZiti"
  homepage "https://zrok.io"
  url "https://github.com/openziti/zrok/archive/refs/tags/v0.4.46.tar.gz"
  sha256 "4232e12557658ddf4dfc85568ece9c49ac29997d0f0fc24eafcb694e2c6ec5c9"
  # The main license is Apache-2.0. ACKNOWLEDGEMENTS.md lists licenses for parts of code
  license all_of: ["Apache-2.0", "BSD-3-Clause", "MIT"]
  head "https://github.com/openziti/zrok.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8401c2213355c5ddddd5ef47f39e1626dc5a04d82452d237d330ab5c6abc1708"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f27ca4a4be82beb09e2cc5a95baa9e05e51f08115c7d4636a6e8594549193a48"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "bac4039ce8422d2ee4b4b7a08314a992f81a7b65939300524b0d900768d3d85e"
    sha256 cellar: :any_skip_relocation, sonoma:        "e76a71e1af21506f50e6824c40a26713514a1bd8e0f9adb08f5e7ffd82140b51"
    sha256 cellar: :any_skip_relocation, ventura:       "d8466d5e5ca07baf2c213a5fb20abc5f817c2a9a4c03f29f43f459aea4ae2c40"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "11c5ca9819f70dfb8eaca60de5eeb4a7897561d700d415939970e2f0f365d42a"
  end

  depends_on "go" => :build
  depends_on "node" => :build

  def install
    cd buildpath/"ui" do
      system "npm", "install", *std_npm_args(prefix: false)
      system "npm", "run", "build"
    end

    ldflags = %W[
      -s -w
      -X github.com/openziti/zrok/build.Version=#{version}
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
    assert_match(version.to_s, version_output)
    assert_match(/[[a-f0-9]{40}]/, version_output)

    status_output = shell_output("#{bin}/zrok controller validate #{testpath}/ctrl.yml 2>&1")
    assert_match("expiration_timeout = 24h0m0s", status_output)
  end
end
