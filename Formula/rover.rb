class Rover < Formula
  desc "CLI for managing and maintaining data graphs with Apollo Studio"
  homepage "https://www.apollographql.com/docs/rover/"
  url "https://github.com/apollographql/rover/archive/refs/tags/v0.15.0.tar.gz"
  sha256 "7592f8f986a63ad38b19b1df4cb4725f56b78ed7360f5d230f96a62e6ed610a2"
  license "MIT"
  head "https://github.com/apollographql/rover.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9b7b65eb14bfd1004e6fbb2aaf56f5b2eaa91687fb8d269851f3764748b41fbf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f16e8ec3b0267eb4ffcd51623e35924631947ae736570bd92433c7534fa99461"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c73dde5bfe37962ed8ebc2ebc26dceea33fd33ed0a6ddebf5c7f59000ee20294"
    sha256 cellar: :any_skip_relocation, ventura:        "766122a070b676f96fb473c91ca8c0ebfaf2aa8c4c8664dc99e9a2229b86a91a"
    sha256 cellar: :any_skip_relocation, monterey:       "0c1862225e8f7e7452712ecf567bb8f504855c9972749f9bc43c6f7f2da91962"
    sha256 cellar: :any_skip_relocation, big_sur:        "d8ed9b865588478530130bafd0613b17e6ee5b1f0b5ee587aeea1bc764b42e33"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d4bfba802345c116dd258a2ef6f63610a85f30708de6437004e02d166fabf80a"
  end

  depends_on "rust" => :build
  depends_on "openssl@3"

  uses_from_macos "zlib"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    output = shell_output("#{bin}/rover graph introspect https://graphqlzero.almansi.me/api")
    assert_match "directive @cacheControl", output

    assert_match version.to_s, shell_output("#{bin}/rover --version")
  end
end
