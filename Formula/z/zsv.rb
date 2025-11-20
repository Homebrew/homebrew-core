class Zsv < Formula
  desc "Tabular data swiss-army knife CLI"
  homepage "https://github.com/liquidaty/zsv"
  url "https://github.com/liquidaty/zsv/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "54c6e2b31cc18c7cca3e345613721545f6fb05873f11bf3afb414950f064386a"
  license "MIT"
  head "https://github.com/liquidaty/zsv.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5a70db05c2a5eb7d47a2495d300f9dfbca9cf06fa9bf36a470392d73afcbb25a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9add2e77a8fdfcb160a17ba859e7c1b8e338062ee6878f508a096d17b2072265"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6db30c39005b391e187cf884b5b227ebe12494d4baea0f1cfcc996ffe2e616c2"
    sha256 cellar: :any_skip_relocation, sonoma:        "75c0c47d69b260a5998933e759df7c44013a94e691dd118e75b423839d213a1c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6626310746cc95e6fb2f65cf80f2010012bf0ee7b38f30b0cdabd95695839960"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f2b487e99f0312f0342f9a79e47a3cebf1fc1f8e8cfb8d1c78c042cd2d0ff5b1"
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
