require "language/node"

class Zrok < Formula
  desc "Geo-scale, next-generation sharing platform built on top of OpenZiti"
  homepage "https://zrok.io"
  url "https://github.com/openziti/zrok/archive/refs/tags/v0.4.20.tar.gz"
  sha256 "caf546a04a3f2e929915e2e66cd573d51f7b8d7b6ed5fa128027fb319bb1333b"
  license "Apache-2.0"
  head "https://github.com/openziti/zrok.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3ce92037f5e898e4a4d6f69a4eb2e277821772cf8d3f7d4f48d7b17cc2cb5f5a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9cd5682ff3878dd9417f25262bedbd04849c6b7d0ffefc2bef3a5aaf19adc224"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0565a4d89128ca5366b8ccb278cbf8db63d5ddda7a91e7a4e5e0d00b8e539236"
    sha256 cellar: :any_skip_relocation, sonoma:         "bf49ce8e962c4c2bfadd065a3b07c9e9f77dddcb1b15d848d45314e0fecd3595"
    sha256 cellar: :any_skip_relocation, ventura:        "0eeda04068271c7bc95c315501fa66ace6ec2cdf2aea24a4e653bca1a66eacd2"
    sha256 cellar: :any_skip_relocation, monterey:       "9120b9de07550e8df9f62b247b11a180e8cb827227ff7eee06b00359ea3373f4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c68b5e14723a1f732e90898b41bdcfbc9433f5205c6450352bb00b28d9ebdc7c"
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
    system "go", "build", *std_go_args(ldflags: ldflags), "github.com/openziti/zrok/cmd/zrok"
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
