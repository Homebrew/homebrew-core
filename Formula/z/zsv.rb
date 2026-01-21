class Zsv < Formula
  desc "Tabular data swiss-army knife CLI"
  homepage "https://github.com/liquidaty/zsv"
  url "https://github.com/liquidaty/zsv/archive/refs/tags/v1.3.0.tar.gz"
  sha256 "251b1f61e8c2371382e9b612f1877c9f1f7ff71d47029ee04f45db89c5f0caab"
  license "MIT"
  head "https://github.com/liquidaty/zsv.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b2fdae13abc1b1e22b1dcac9a2da1eb55f010dca80f7cf311dd69fe4cd7196e1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e2c2b5647f504f93e9b93bd3bf95b8109cff5ade016f94cd9d88fc84cde1ffba"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d91d65dc761c247db36d9ce086133ee63c987a38b2ce53f60b7b1305598bcff2"
    sha256 cellar: :any_skip_relocation, sonoma:        "ef2b52a21d84f9b3549a108234e471b7573e995716066c60b38bd4bb9c13f090"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1caede721d04f19432a2b4566772c5ee37c2081a72fca2e7c8ffb78ae8c133ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9f12396502a16441e4b71b78c1c261b23e4ed0ea426f8e013be71eff2c3740d0"
  end

  depends_on "jq"

  uses_from_macos "ncurses"

  def install
    system "./configure", *std_configure_args

    ENV.deparallelize
    system "make", "install", "VERSION=#{version}"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/zsv version")

    input = <<~CSV
      a,b,c
      1,2,3
    CSV
    assert_equal "1", pipe_output("#{bin}/zsv count", input).strip
  end
end
