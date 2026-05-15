class Teller < Formula
  desc "Secrets management tool for developers"
  homepage "https://github.com/tellerops/teller"
  url "https://github.com/tellerops/teller/archive/refs/tags/v2.0.7.tar.gz"
  sha256 "1d4275ede4366a31efc94039c58da4cec87466d09cc01444c3c18e9432716d23"
  license "Apache-2.0"
  head "https://github.com/tellerops/teller.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "c3ab62c1579d3f41b3642fe3b3170a8c116be3abb320b09aac2c8f37b5ad51ef"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "a9e07be61dd9142e5650014b5f8ef4df9bf689dc59d1b2a4e8825554db831ea2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "703d3907b7c26f917c3fe9fd1e87cad407a54c9f687104bf0b99a0027a91bfc7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a778a5408aa36e9c37b43b174e836bec8b3a33e47c277fe1848bca16e138f159"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ee1a519ff52b6ac79cf9452148c1e43da20f53b3c480c4e6c720dc6eaa7aa1d9"
    sha256 cellar: :any_skip_relocation, sonoma:         "1e8cec0e0438ed0d2fd78f55732c0e25817a5f5b29abec395feab13ed7064ce4"
    sha256 cellar: :any_skip_relocation, ventura:        "ef538ec71a01c3d9c720834548d1d1ef69c188e3b35af336aa929cdbcc410dcf"
    sha256 cellar: :any_skip_relocation, monterey:       "6a2c68920ddfa793d15b9929c3776bdf57dae94c1bba39a3ecc98b469971fdf2"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "732e1ec643cafa019abff281687553156cb58b234b896f4294617137b37c21bc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d5a575efbb6d5fc01d43cd7ba2f6df6c0fc121e696b7b176a8b309c55b955503"
  end

  depends_on "pkgconf" => :build
  depends_on "protobuf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "teller-cli")
  end

  test do
    (testpath/"test.env").write <<~EOS
      foo=bar
    EOS

    (testpath/".teller.yml").write <<~YAML
      project: brewtest
      providers:
        # this will fuse vars with the below .env file
        # use if you'd like to grab secrets from outside of the project tree
        dotenv:
          kind: dotenv
          maps:
          - id: one
            path: #{testpath}/test.env
    YAML

    output = shell_output("#{bin}/teller -c #{testpath}/.teller.yml show 2>&1")
    assert_match "[dotenv (dotenv)]: foo = ba", output

    assert_match version.to_s, shell_output("#{bin}/teller --version")
  end
end
