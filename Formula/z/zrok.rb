class Zrok < Formula
  desc "Geo-scale, next-generation sharing platform built on top of OpenZiti"
  homepage "https://zrok.io"
  url "https://github.com/openziti/zrok/archive/refs/tags/v0.4.41.tar.gz"
  sha256 "aa7adb3cc25ea192afadbb8e7e99d51e5ae2244c1abab62068d313fac5865291"
  # The main license is Apache-2.0. ACKNOWLEDGEMENTS.md lists licenses for parts of code
  license all_of: ["Apache-2.0", "BSD-3-Clause", "MIT"]
  head "https://github.com/openziti/zrok.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d27e13cb498f612bcff87682c9755b71fe5254013a2f1a205d7b1ad537a85e79"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "13ce271557bc9e12a740eeed2d3593b3610aca95627e76efaafebd74d5271f3b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c190bafd3076f34eb132b639675dfa75b5e64c315317c0a11ce21a5de4163888"
    sha256 cellar: :any_skip_relocation, sonoma:        "69fc5ace4e39c11836309803bc51d95f7585557f899c72760d1f066da0217856"
    sha256 cellar: :any_skip_relocation, ventura:       "9283cde532a46bbc8503c6f14ea869ea46afc6a736010f8ea02125f60cf93969"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9135827cce30646269f8aa52f8d58fc3c1c0a7c1cd63041e09c80911b91086bd"
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
