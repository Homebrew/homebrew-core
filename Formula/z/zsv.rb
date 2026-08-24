class Zsv < Formula
  desc "Tabular data swiss-army knife CLI"
  homepage "https://github.com/liquidaty/zsv"
  url "https://github.com/liquidaty/zsv/archive/refs/tags/v1.4.3.tar.gz"
  sha256 "8372ec277b0cf56d02e3407e355208875fdfa174a3ed01e6ffb9a00fe440fc43"
  license "MIT"
  head "https://github.com/liquidaty/zsv.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "6be15b2dd78ab48e73b3e57f09cd76596101f5399abef6c195acc723133b7a54"
    sha256 cellar: :any, arm64_sequoia: "0c0ecf8e794b0b3677f2f205e05fecbcdaf4391031c46acc39758943122daf07"
    sha256 cellar: :any, arm64_sonoma:  "1a1adf05e6279342d927c488e87fe83bf13fe2467859f5ecabab28e8e2a2712d"
    sha256 cellar: :any, sonoma:        "c42681fd56cbaab5e8e43b88e8dac08dfc1913470cfb2734ed24a10c7ecca354"
    sha256 cellar: :any, arm64_linux:   "1d03459e6026abfa066b20bb90b66b9f4633211e43c7086e7ad63a7e02f07da6"
    sha256 cellar: :any, x86_64_linux:  "2b197d1ba38c26efdd5c7d627121a5eb07ce2bb304ad14c388e0e0dd5b3521bb"
  end

  depends_on "jq"
  depends_on "pcre2"

  uses_from_macos "ncurses"

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
