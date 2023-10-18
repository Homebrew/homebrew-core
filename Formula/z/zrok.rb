require "language/node"

class Zrok < Formula
  desc "Geo-scale, next-generation sharing platform built on top of OpenZiti"
  homepage "https://zrok.io"
  url "https://github.com/openziti/zrok/archive/v0.4.9.tar.gz"
  sha256 "3f7dd8620f32031cfd71a8fb3fe8044d5312a69379ae9ac4a9e7956afdedf563"
  license "Apache-2.0"
  head "https://github.com/openziti/zrok.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1722d35c292a2fe686e1ae31bf423ee78613d1e262df92b28a3d034061f01edf"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "03722e24fb2fe099586dcb64671898a22b344b4dac2ac40f0b690126800e7906"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "62e2222ef5434cb730d734d8b76313f686873f2c29352e8855e83a00692c2695"
    sha256 cellar: :any_skip_relocation, sonoma:         "41a7ae98a87a088fc93285467bba81ccd12f6d90fef3643217cf7a452f9d4457"
    sha256 cellar: :any_skip_relocation, ventura:        "6cd76a1ef4dae8d197aeabb55202f00246f7ccad1fb075a66f02957db31afbd8"
    sha256 cellar: :any_skip_relocation, monterey:       "5aabdf0c69ad998208105a7c1d5eb37e098819be119c642d02e006a8efc2ed14"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b763da9f0f45e2aee4e42ac3e4fb5a327cdcc0fa3828e031a7b495f28f406a4e"
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
