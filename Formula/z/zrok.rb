class Zrok < Formula
  desc "Geo-scale, next-generation sharing platform built on top of OpenZiti"
  homepage "https://zrok.io"
  url "https://github.com/openziti/zrok/releases/download/v1.0.0/source-v1.0.0.tar.gz"
  sha256 "2980581c45514240598135deed8a999bc65359527ded31a5bb855d05e70f2254"
  # The main license is Apache-2.0. ACKNOWLEDGEMENTS.md lists licenses for parts of code
  license all_of: ["Apache-2.0", "BSD-3-Clause", "MIT"]
  revision 1
  head "https://github.com/openziti/zrok.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a701fe9ad7f4e1672e5d22ef3d2f0ac7d0a8d886b60d9199efc72dc5914a96ab"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d7110048ebb57c75c64040758497bd0f566f2e0df6d8361ff71b4fe2faf9dd8b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "949a3f94b23f91f365ec3c0d3ff5289b5ddab4550117059f614a7ac406ac28b0"
    sha256 cellar: :any_skip_relocation, sonoma:        "4588ec2cf25b480f33941b16e51fe212861754e24a55412b6fb5321b75f1172d"
    sha256 cellar: :any_skip_relocation, ventura:       "bb4c14e51334372b7faa45125ffb561d6a295bbf016ec87a13f4a88836a49d4a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e51c1c81f855c01e57308adc8c2fde57eee08a7f08ef1b160d30fa98a129b6ae"
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
