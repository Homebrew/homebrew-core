require "language/node"

class Zrok < Formula
  desc "Geo-scale, next-generation sharing platform built on top of OpenZiti"
  homepage "https://zrok.io"
  url "https://github.com/openziti/zrok/archive/refs/tags/v0.4.26.tar.gz"
  sha256 "f89824d6b93c3a88958344d164211532feaa9704ca7961388caa14829a27a6fb"
  license "Apache-2.0"
  head "https://github.com/openziti/zrok.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "761c5c794a743449b0d8c48209ca5330adf9c3fd91f632ab5a2fa66fd5f35401"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c5f852e23b976d813739aa58c47ab0d9418fdd4f9dc7d4eeda3ba1608d81434c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bd9f43d9b1fbc0979114b98d5acb36e7d083610b8ffcb7a8db4a4bcd9a29b912"
    sha256 cellar: :any_skip_relocation, sonoma:         "b05382a364f95d91cbe9549657e488012b52a4e6eb51ab977ab35882b82bbed6"
    sha256 cellar: :any_skip_relocation, ventura:        "eab3183c368bfa409d695878fd43780842405e0ab579e373a512d1644876fb2f"
    sha256 cellar: :any_skip_relocation, monterey:       "fdda872c918847ff0ab42d05c1b20539158b8e1e35972b36a9e7e173426291ae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9e6b75d3764051098020b220b7e81fedd73cf058ab1657d2da6e2195c103928f"
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
