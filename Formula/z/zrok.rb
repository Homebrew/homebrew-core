require "language/node"

class Zrok < Formula
  desc "Geo-scale, next-generation sharing platform built on top of OpenZiti"
  homepage "https://zrok.io"
  url "https://github.com/openziti/zrok/archive/v0.4.7.tar.gz"
  sha256 "c42f8f730c791f506cdb80734e64672a3e10e59335a816db628b056c8ee4830a"
  license "Apache-2.0"
  head "https://github.com/openziti/zrok.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c9ce17f7dad44c28e30acd698a2b5907f8c88600095104d61ac628f6095de9ee"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "81139ce1a01089d21c6542df88e6928857436fe0c8ca57d214daf0782f0959ed"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "48810723c7297d5b000041bdefc988db8a7987250725d90346e3aac57abb2915"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b75ef7bde83314de14176a81a26d791e18ffbf09c8e3c45d826b6288648aa8cd"
    sha256 cellar: :any_skip_relocation, sonoma:         "a96c3369bee4b79e7597d85d45cd036561597022a52d19524459c2618a8000dd"
    sha256 cellar: :any_skip_relocation, ventura:        "3e2be753b4af73f7fa05e5cac258e39c9f2b3066f76f49027eef21f84c2cf742"
    sha256 cellar: :any_skip_relocation, monterey:       "de9753ad13d7b96803c51703251219e7b5fc4004a251c350711f23ac7613ab25"
    sha256 cellar: :any_skip_relocation, big_sur:        "2d906e07771921f787421c65ad81109ff14617cf127054e80e244655347e3f75"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "79107692887f4e67445b0810a33d70b394afd5467c04be04fd49c90629f33fc6"
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
