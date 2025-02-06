class Zrok < Formula
  desc "Geo-scale, next-generation sharing platform built on top of OpenZiti"
  homepage "https://zrok.io"
  url "https://github.com/openziti/zrok/archive/refs/tags/v0.4.47.tar.gz"
  sha256 "b9364b1bb41bdd83aedd64ce1e3d07e0415df269a17186c8d2cb0b09fc5c4e27"
  # The main license is Apache-2.0. ACKNOWLEDGEMENTS.md lists licenses for parts of code
  license all_of: ["Apache-2.0", "BSD-3-Clause", "MIT"]
  head "https://github.com/openziti/zrok.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6cdde19fc1126fb650c405cc9cc0cab984cd77d06a8f1c1ca94fb756d884c867"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "86bc70cbd30dac106e38597d109e2786ad0f898b82ce27c1a843b1e18cf35fa7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e028dbe405847a17cc378ebcaf81e899ceaf7b4af0a60d7a0d70b8b86e6efcb5"
    sha256 cellar: :any_skip_relocation, sonoma:        "f885085d1c487dabb672d70a6337c985b87adf0ae9e38836b0bffff5aed4a349"
    sha256 cellar: :any_skip_relocation, ventura:       "7b6114f0a55e2860d195441fcbbdeef007402dcea8f9cd130f27f0a5ce26190d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bcc15ffaaddd324e32d749e6840f693f3eb71aaca7472cfba85fc4a71056a2a0"
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
