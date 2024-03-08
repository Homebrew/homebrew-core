require "language/node"

class Zrok < Formula
  desc "Geo-scale, next-generation sharing platform built on top of OpenZiti"
  homepage "https://zrok.io"
  url "https://github.com/openziti/zrok/archive/refs/tags/v0.4.26.tar.gz"
  sha256 "f89824d6b93c3a88958344d164211532feaa9704ca7961388caa14829a27a6fb"
  license "Apache-2.0"
  head "https://github.com/openziti/zrok.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4af7efba729d22e7cacf2de6724cde6bea49c8a71730974df685f5e0897b9e1b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "35ba4586f965a3f3188deb278a5b02f909e4431f868b1e9d1502dffe69f9514d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8cc7b45e2b8ef0006b842e4d340262f58b0614168564bf71caefb6bebf9f818c"
    sha256 cellar: :any_skip_relocation, sonoma:         "7a7e299ea44947158ee043b48765e5da1448655f027f8776d707fd96b25879e1"
    sha256 cellar: :any_skip_relocation, ventura:        "cdacf8048739a95f77093b92aadbe29ec53344fc44377d445710d0f229a88c2a"
    sha256 cellar: :any_skip_relocation, monterey:       "1c951b092f93c1ef9fb8c564cff14d76f1cda788f5edf34604bc20abae8fe13c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f86f0bf3bc4190f5565571d08817f60878e4f3505d16dafa7b3f4593611b3393"
  end

  depends_on "go" => :build
  depends_on "node" => :build

  def install
    cd buildpath/"ui" do
      system "npm", "install", *Language::Node.local_npm_install_args
      system "npm", "run", "build"
    end
    ldflags = ["-X github.com/openziti/zrok/build.Version=#{version}",
               "-X github.com/openziti/zrok/build.Hash=brew"]
    system "go", "build", *std_go_args(ldflags:), "github.com/openziti/zrok/cmd/zrok"
  end

  test do
    (testpath/"ctrl.yml").write <<~EOS
      v: 3
      maintenance:
        registration:
          expiration_timeout: 24h
    EOS

    version_output = shell_output("#{bin}/zrok version")
    assert_match(version.to_s, version_output)
    assert_match(/[[a-f0-9]{40}]/, version_output)

    status_output = shell_output("#{bin}/zrok controller validate #{testpath}/ctrl.yml 2>&1")
    assert_match("expiration_timeout = 24h0m0s", status_output)
  end
end
