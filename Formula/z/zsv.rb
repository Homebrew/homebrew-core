class Zsv < Formula
  desc "Tabular data swiss-army knife CLI"
  homepage "https://github.com/liquidaty/zsv"
  url "https://github.com/liquidaty/zsv/archive/refs/tags/v1.4.1.tar.gz"
  sha256 "c58939985dbb9750469284a32ae6cde850ca599fb031977b540de8b2c61f644c"
  license "MIT"
  head "https://github.com/liquidaty/zsv.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "997ea4dbce75715183cd0e7d1e43367a0de9e16c78df0e41ca55d95078b63229"
    sha256 cellar: :any,                 arm64_sequoia: "59360bdb6c9b6e73aa19b977eae512a57242c2d7b15c000435acec98c24bd6a0"
    sha256 cellar: :any,                 arm64_sonoma:  "48bcfbb029c90895b6feab493d38580560ee44ed8fe27cfb9b71e68b23dbe69f"
    sha256 cellar: :any,                 sonoma:        "27c4666e155d474494eb2df6582c1aed93fc7b78c3bf6a82879024435773ddc8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0fef2888d1a3e274f0b3764cc157bb83ed5d71c3561ff40d2a4feb98af622f29"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d9b1e9626221ed2494a1472c7cfb6e3dfe4875f18bf3b24658f89ceb0568834f"
  end

  depends_on "jq"
  depends_on "pcre2"

  uses_from_macos "ncurses"

  def install
    rm(Dir["app/external/{jq,pcre}*"])

    args = %W[
      --jq-prefix=#{Formula["jq"].opt_prefix}
      --pcre2-8-prefix=#{Formula["pcre2"].opt_prefix}
      --ncurses-dynamic
    ]

    system "./configure", *args, *std_configure_args
    system "make", "install", "VERSION=#{version}", "PCRE2_STATIC="
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
