require "language/node"

class Zrok < Formula
  desc "Geo-scale, next-generation sharing platform built on top of OpenZiti"
  homepage "https://zrok.io"
  url "https://github.com/openziti/zrok/archive/refs/tags/v0.4.31.tar.gz"
  sha256 "2f44a042ec5681e9da4a31d931c5e1826d4518d115758464bf77738f7b1eb9fe"
  license "Apache-2.0"
  head "https://github.com/openziti/zrok.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "008a6b91091cf6e7a5be267d223575ea96ee9c06a791b14d6c44c792304eaf36"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "388a127aa620a96140b859e4a49838e7957e2397fd1055bfa691dc2f64fbdecd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4c86bb4809d48fc652b6beed24b5949d7ac97e1386b2191678a0d861f64b8172"
    sha256 cellar: :any_skip_relocation, sonoma:         "775e9bf49435c763ab8dd0129f70294fd5915b4e604cf0b38b8a0ebacfa19598"
    sha256 cellar: :any_skip_relocation, ventura:        "f372d276a0e19122d220ab07ecb613a850a8fb3924089db9b3d9146587ea27ad"
    sha256 cellar: :any_skip_relocation, monterey:       "d78a2bb78bf13c74964f10cb614da7ba49eae535b4e04806027be3ccd8249191"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "039799f5a6b51ba84ac67869c29b24c620f4bf4f70f437b0e6d9745f45471c6c"
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
