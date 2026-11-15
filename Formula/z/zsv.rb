class Zsv < Formula
  desc "Tabular data swiss-army knife CLI"
  homepage "https://github.com/liquidaty/zsv"
  url "https://github.com/liquidaty/zsv/archive/refs/tags/v1.4.4.tar.gz"
  sha256 "99486b6901d6b576bf15afceb0bcc888ceeb3f555a6d489547eefe67eff52079"
  license "MIT"
  head "https://github.com/liquidaty/zsv.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "61cf2d5f83cda7d65589f2e3eb25075c678999ad49a5c1f7c8c981f4db63f714"
    sha256 cellar: :any, arm64_tahoe:       "0385e07e82fb155bc58b105985655ce5bbb71d3976acf23bd1496df0063a12ef"
    sha256 cellar: :any, arm64_sequoia:     "e6a20199421a90f61baf9b96dc9818b829ddd9828085da7b42b8cf3d7f0b93aa"
    sha256 cellar: :any, arm64_linux:       "9944c7a7e618a09bd802d433970f78a2eaf42391f9c5e6ce20e5fcb8c63b1804"
    sha256 cellar: :any, x86_64_linux:      "09bd764987e189b0d773102eee2831ef080cd0342e57841876adc27a8ee56b08"
  end

  depends_on "jq"
  depends_on "pcre2"

  uses_from_macos "ncurses"

  deny_network_access!

  def install
    rm(Dir["app/external/{jq,pcre}*"])

    args = %W[
      --jq-prefix=#{formula_opt_prefix("jq")}
      --pcre2-8-prefix=#{formula_opt_prefix("pcre2")}
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
