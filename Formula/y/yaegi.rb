class Yaegi < Formula
  desc "Yet another elegant Go interpreter"
  homepage "https://github.com/traefik/yaegi"
  url "https://github.com/traefik/yaegi/archive/refs/tags/v0.16.1.tar.gz"
  sha256 "872ceac063a8abfa71ecdeb56b1b960ca02abd5e9b6c926ae1bd3eb097cad44b"
  license "Apache-2.0"
  head "https://github.com/traefik/yaegi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "89e8681d4dc369e762c31e42208290ede00c1d8972589b341bcfcb9efd006d5b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ee7a0dc7902daca4935063a8e4bb0ea6199bf55e9e189dd84ba7d57a98d926a2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fc2e80bb7ff631f962888c45a903a258c2f6301339e6c13a3cdb350163b8e4b5"
    sha256 cellar: :any_skip_relocation, sonoma:         "6ccd53e38ce8ebfc4739287ccbc67f02757eb1f0bf0fc7945b3d2d5daa512872"
    sha256 cellar: :any_skip_relocation, ventura:        "0fa9ed0e7f81673bb63a6863511741a6280f5531e5ca2faead31aa501ea8ab8b"
    sha256 cellar: :any_skip_relocation, monterey:       "e8fb11c381549bc6c5aa6036443f15ff6e07ec9fe613021a00d550abfd313e1b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "61ace260eae8744151743b8e6f3d0601f4b31e4d7f0eabe5446c332c7014f5d1"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-X=main.version=#{version}"), "./cmd/yaegi"
  end

  test do
    assert_match "4", pipe_output("#{bin}/yaegi", "println(3 + 1)", 0)
  end
end
