class Zrok < Formula
  desc "Geo-scale, next-generation sharing platform built on top of OpenZiti"
  homepage "https://zrok.io"
  url "https://github.com/openziti/zrok/archive/refs/tags/v0.4.42.tar.gz"
  sha256 "2a6ad8562832a880586c0179e4fcca05625d990ae33f98cd42a1ddeed45c184d"
  # The main license is Apache-2.0. ACKNOWLEDGEMENTS.md lists licenses for parts of code
  license all_of: ["Apache-2.0", "BSD-3-Clause", "MIT"]
  head "https://github.com/openziti/zrok.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3aa399dec0d17aced2e5949c82207d19d72f720a243166620ab755146e71f7ea"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "df86a4a05c75dba79ea974ebcd6de8a015c2ea2f2a73f7f668118c99b46e3e4b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d310cef500e4b7684281d9e9a0041e84cd6ae84cd3e65e5a4adcb68f87858f50"
    sha256 cellar: :any_skip_relocation, sonoma:        "2873a375802211e4e3b8877637f5c5fcdbb30a8202b548a39baf48544387b6de"
    sha256 cellar: :any_skip_relocation, ventura:       "a427202881381dc669b6bc5c0a1c10d424e043427760a2f14a5897a0b02f195c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5b31b98b5fc6d9a482252987c70dd6f21a22a655ee6612abbe4daa33256bed49"
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
