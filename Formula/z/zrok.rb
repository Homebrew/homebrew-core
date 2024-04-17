require "language/node"

class Zrok < Formula
  desc "Geo-scale, next-generation sharing platform built on top of OpenZiti"
  homepage "https://zrok.io"
  url "https://github.com/openziti/zrok/archive/refs/tags/v0.4.27.tar.gz"
  sha256 "7009c4ad2cb494eb9d36cc3c0b159021b4f9d53df57db5c4dfdc168b3c78c72c"
  license "Apache-2.0"
  head "https://github.com/openziti/zrok.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "dd92e212369672c38aa7cefb9da3df0c130a51a66711185d9a7545f9976f6ff2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f955a2682bb6d255297f1cac9e121adc0bfd1db5564ca83889ad4efcb9c6f3a9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f0ec3110f787414cab0fb6ee6733d73be98dd43f817c111fdd1a8cd35da59036"
    sha256 cellar: :any_skip_relocation, sonoma:         "604a65d23daafdbfdf2b073a50e2b0677954e7809a3a22a36bed1fbe9fb9451a"
    sha256 cellar: :any_skip_relocation, ventura:        "4f19505ed7cf0d2e75a297e3ab7b2409e9e080f7d96324b7448bdf38e36474cf"
    sha256 cellar: :any_skip_relocation, monterey:       "dea2cd9ba38778b7e0fd09434988a875ef0a567d717d7abe025b6d0707a6fb8d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2fee31b0fc57417b72a611ea882bc6900b3bd5ffdbcd35e8721c7f9256c346ee"
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
