require "language/node"

class Zrok < Formula
  desc "Geo-scale, next-generation sharing platform built on top of OpenZiti"
  homepage "https://zrok.io"
  url "https://github.com/openziti/zrok/archive/refs/tags/v0.4.23.tar.gz"
  sha256 "4ca9c52b8ad56498fe3cc73a65e0f6381f1d1afa2f9be2c569dc6f2e3fb810f9"
  license "Apache-2.0"
  head "https://github.com/openziti/zrok.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2a232c1698355d61dae1f1f9873f49b440f5dea1a53daafe9df0b4717f57d982"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ab382a3250f40db8ca0863ec34d7db976840c455169c2e57c3543a4a9605d829"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a71231a5a7ae91861e4be9c1feb3b16aa90d913a9e56476046565bdc42d69ea1"
    sha256 cellar: :any_skip_relocation, sonoma:         "cb22a2f93c0afcaebcf8768bb56176b8be746a2513f8a08e96b6e6da9b3b83ad"
    sha256 cellar: :any_skip_relocation, ventura:        "d8d5a48ee9a15f8548f646aa299dc673ec14fc757b3ec521172c4709c67346d1"
    sha256 cellar: :any_skip_relocation, monterey:       "621a10926d8376eea6990a1c80d69301a7eb42bec79047bb3b45ec255c5b5d4c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "592f940db510bf3c316d35122d27c12eae4843a0dc729707d1e0928b3abcf614"
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
