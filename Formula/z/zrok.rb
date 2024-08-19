class Zrok < Formula
  desc "Geo-scale, next-generation sharing platform built on top of OpenZiti"
  homepage "https://zrok.io"
  url "https://github.com/openziti/zrok/archive/refs/tags/v0.4.38.tar.gz"
  sha256 "d1aaa8b879200400cfa70ecfd2aceed698d51f55fc6dd1625de9254cfb2a92c7"
  license "Apache-2.0"
  head "https://github.com/openziti/zrok.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1bac443394ff09290b438089b1bd9a6d4f5950e351bf9332be1e82ed0d1ab9b9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0ad4e62aac0bdff70057f8bfe06c1315d7df5aa96ff4bf17dbfec9b18d65dc58"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "31a1054dc595547c6fb838f2bfdca8fb36abfb15e0a488e2d471d0528c9a034a"
    sha256 cellar: :any_skip_relocation, sonoma:         "acb78bb6490b99a4b702d3a4f72d274f90694735d8d3b6ca3d8c8ab3b37431a6"
    sha256 cellar: :any_skip_relocation, ventura:        "9e110467ee5b6875222b99774a1b81f64a2fbdb268da7c1dbab921b4289d5d27"
    sha256 cellar: :any_skip_relocation, monterey:       "fb0dd05fbd1f1c5b180d9694d24a138f96e7e7dc6ab9761efccf78778d3ad3bf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e87e3ce53c853899891ee3ad5f31b03af63843dfb9d9226ef51ab835600be30d"
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
    (testpath/"ctrl.yml").write <<~EOS
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
    EOS

    version_output = shell_output("#{bin}/zrok version")
    assert_match(version.to_s, version_output)
    assert_match(/[[a-f0-9]{40}]/, version_output)

    status_output = shell_output("#{bin}/zrok controller validate #{testpath}/ctrl.yml 2>&1")
    assert_match("expiration_timeout = 24h0m0s", status_output)
  end
end
