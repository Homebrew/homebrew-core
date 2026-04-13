class Zsv < Formula
  desc "Tabular data swiss-army knife CLI"
  homepage "https://github.com/liquidaty/zsv"
  url "https://github.com/liquidaty/zsv/archive/refs/tags/v1.4.0.tar.gz"
  sha256 "939fb66d4885260ebe52cc280d131a3973886a37b9ac5db0fe8be18e27c4c31c"
  license "MIT"
  head "https://github.com/liquidaty/zsv.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "9cf74a76ac5f958a5abb51420f152b54494c18024406f3ac1dc67806c6f2e6ba"
    sha256 cellar: :any,                 arm64_sequoia: "8dac7e816ec70957c6ed14f404e95172ecdb28437cccfc26d5cb0f179a0459d9"
    sha256 cellar: :any,                 arm64_sonoma:  "ad4d4068e736dad481ed4da93223fac5e86d1cbb1d8631bb7ace73ae7e749cf0"
    sha256 cellar: :any,                 sonoma:        "af0128af6d66a726aed4e3fc0cdabc599eb9646b768e78bf75de9153f5430ba8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5e9e57c23352087eca53556b2fee0d9643faeaaa523680054e5659124783c669"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a8a977ce589211e1c35e826cec28aabb021ff58b930313087bc0a5afceefe564"
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
