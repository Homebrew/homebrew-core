require "language/node"

class Zrok < Formula
  desc "Geo-scale, next-generation sharing platform built on top of OpenZiti"
  homepage "https://zrok.io"
  url "https://github.com/openziti/zrok/archive/refs/tags/v0.4.24.tar.gz"
  sha256 "5c258c61364508646f95cd93e7be6bf1b1c6712347c0d226fa7b66ef9d3a02ae"
  license "Apache-2.0"
  head "https://github.com/openziti/zrok.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "deb6d040ac15430f086d87b613114626d0a7ad876586fdbf8d7d3538a026c001"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e4a94b22fca7013a072c7f096d1f892b86e627504d1614dcd094136165c10f2d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2fc60946f97907972c5c86d3937e9b4f14981600e21585538cc5d923e3ae5229"
    sha256 cellar: :any_skip_relocation, sonoma:         "3c5aa803e0bb66c2842ca7203f770251739eceef38ffd8dc01de08b237d4ea65"
    sha256 cellar: :any_skip_relocation, ventura:        "8a1b533a9daca0b1114dd10cfb9149c2c6ddf98e9856dc093d5bbb14e0a9d562"
    sha256 cellar: :any_skip_relocation, monterey:       "a05e67fa2e4be9d58dd1ebb2e37052c89ecfb7338f4051afe02432c860a0c654"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "49eca8e57a47a6a45cce0a1b9cb293add9e967e01439dbf5420844ff8888632a"
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
