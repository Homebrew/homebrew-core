class Zsv < Formula
  desc "Tabular data swiss-army knife CLI"
  homepage "https://github.com/liquidaty/zsv"
  url "https://github.com/liquidaty/zsv/archive/refs/tags/v1.3.0.tar.gz"
  sha256 "251b1f61e8c2371382e9b612f1877c9f1f7ff71d47029ee04f45db89c5f0caab"
  license "MIT"
  head "https://github.com/liquidaty/zsv.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "76284618eb9197f6a95662fef7b0561317264ca45478ca0b618c7cade04715af"
    sha256 cellar: :any,                 arm64_sequoia: "ab57f85786b1350ecb12706551c04d19bc9648f7cc85797e8a20781bf16304a9"
    sha256 cellar: :any,                 arm64_sonoma:  "90368dd0b65b8302ba68063510aae8c2df88195c906167adb3aa4bf4caa0559a"
    sha256 cellar: :any,                 sonoma:        "f98f1e5a3782f5ef64573d80acfe89e75e7793dd56ea574cec7cad2cca30c4af"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e195404e9bc473770a34909d508a813dea95c0b3bb64e0b4e3d618bb3d060c9c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "32cb9126d5d14d886c92d2e12b4e71cd7d45c3c6e1e6789b289f531db60a05f6"
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
    ENV.deparallelize
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
