class Rover < Formula
  desc "CLI for managing and maintaining data graphs with Apollo Studio"
  homepage "https://www.apollographql.com/docs/rover/"
  url "https://github.com/apollographql/rover/archive/refs/tags/v0.12.2.tar.gz"
  sha256 "bbb04e68a8772f46daae1b19840640026f1ba8d7202557b15a90b10259ec3090"
  license "MIT"
  head "https://github.com/apollographql/rover.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c8a43ddcca47a2e90a1f6d793254ad3e98ae53970651d0aded5daaefc547e4d0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5d2eba73bd729e9a5d738bc7bdd3d3d38fee88a7054bfe7c0ae52f9b04a42889"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b8093ae0ebeb15690c739638262553363affc02fdb0163e56cdeec9209d3eade"
    sha256 cellar: :any_skip_relocation, ventura:        "64a77af0c3cbf05cd37324c8af20aad5df646332d7f3382e051f98c465996058"
    sha256 cellar: :any_skip_relocation, monterey:       "8ffd61444ed8fa0dbf3a8e656f6302aa1fef198a85781b2da5d7bfd441b36c24"
    sha256 cellar: :any_skip_relocation, big_sur:        "0442a6c8d1fcd0b534391778bd833358fb9bd8280bdb84dfafa0bd2f2199cb18"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "edd462e60d7dd538a35f5d5005a28c4a29655aa51a3b88897422eed2e8054618"
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
