require "language/node"

class Zrok < Formula
  desc "Geo-scale, next-generation sharing platform built on top of OpenZiti"
  homepage "https://zrok.io"
  url "https://github.com/openziti/zrok/archive/refs/tags/v0.4.34.tar.gz"
  sha256 "7ba4c46809f39876723cf4647e9665c78df0b4382c3b629db848d07d803862a8"
  license "Apache-2.0"
  head "https://github.com/openziti/zrok.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e8dd2dea77d514bd4b3b27fa7cd974c9cc4797b761039c9faa2e9e972f85d9fd"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f76b2b53c333fd2751f808e56ae4befe84afca79d9e0dd41defab663fdf1cc2a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6a097c2bfe72612c1ed1f46f1eb91bf12d41ac5c6afb267c1250f4bff0507855"
    sha256 cellar: :any_skip_relocation, sonoma:         "8e45a80a642336e059a44c446a06bf9f476708e27487f8b96d9d1fdeba01c6a5"
    sha256 cellar: :any_skip_relocation, ventura:        "6d06e948ca48df0eceb70ca7ad396120f60a0f08874959eeb12c8c02ea8067a2"
    sha256 cellar: :any_skip_relocation, monterey:       "9536b1ba040a5d8a84b1cd23ae21fac9132ad7f4f0d18fee24e8575f781484b5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bedee4d7897019635df0169b66b8c159fa65ba68e1d1dc29c64c4497ba73f7e0"
  end

  depends_on "go" => :build
  depends_on "node" => :build

  def install
    cd buildpath/"ui" do
      system "npm", "install", *Language::Node.local_npm_install_args
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
