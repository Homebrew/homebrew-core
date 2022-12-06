class Tbls < Formula
  desc "CI-Friendly tool for document a database"
  homepage "https://github.com/k1LoW/tbls"
  url "https://github.com/k1LoW/tbls/archive/refs/tags/v1.56.9.tar.gz"
  sha256 "132d4e491a55815f6da79a202d54e2fe52daf285bfa3fb0c6b599c2d16fe0b31"
  license "MIT"
  head "https://github.com/k1LoW/tbls.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7078246e46f884f4333a420d8ac209e7b40341a01ba0db94ee8a18c342a0cafd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d434c11de8b03467f3f657ac90287f061f8f45bb55c3c78cd9033c8e04d50364"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2b211e255fd00885558233701b0253d0cc9f8c82d4f12a1c86b583c8b49c8ebb"
    sha256 cellar: :any_skip_relocation, ventura:        "83b53c74e96a1cf5dcf599169466883dd924dc33a3120fc2603ee03a89388635"
    sha256 cellar: :any_skip_relocation, monterey:       "94536517a066c2213796a8af2a715cab90bb8609b22803f104c8a656dfea9363"
    sha256 cellar: :any_skip_relocation, big_sur:        "72d9835dcaa1f0fbdb83dfa663db1e29194037a555ec6c8f752c2fd638522be6"
    sha256 cellar: :any_skip_relocation, catalina:       "fe5f756012c29f2652c72a2aba50bf1aea844101970318ea996861ef6b02964b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1ce399126de709028be9b9331324eab5b70aa33c2aaacbff5f7b2fcc0f327807"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/k1LoW/tbls.version=#{version}
      -X github.com/k1LoW/tbls.date=#{time.rfc3339}
      -X github.com/k1LoW/tbls/version.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)

    generate_completions_from_executable(bin/"tbls", "completion")
  end

  test do
    assert_match "invalid database scheme", shell_output(bin/"tbls doc", 1)
    assert_match version.to_s, shell_output(bin/"tbls version")
  end
end
