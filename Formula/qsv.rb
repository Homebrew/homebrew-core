class Qsv < Formula
  desc "Ultra-fast CSV data-wrangling toolkit"
  homepage "https://github.com/jqnatividad/qsv"
  url "https://github.com/jqnatividad/qsv/archive/0.69.0.tar.gz"
  sha256 "8a4c29c4253afe2265349b735abe052c8c4e677572e4c1826117a51009cdec76"
  license any_of: ["MIT", "Unlicense"]
  head "https://github.com/jqnatividad/qsv.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fcabb6b59afe8a624b924e7cb8d95e2bb565851851a74773df19148a1e68bc0f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7979cbce89cf23f0c6872598418905eeba1ecd4941456f4b94aadfac871c9718"
    sha256 cellar: :any_skip_relocation, monterey:       "cc77ee5bbda942711fd64fca5fc73ac46e3a95dc65fdde22b4b7280a07f81161"
    sha256 cellar: :any_skip_relocation, big_sur:        "ba4fb11c01b967b2b03d63961d7cacb2d30c40e37b72e588a4dee2a109e27c3f"
    sha256 cellar: :any_skip_relocation, catalina:       "0339ca3f5dc64ccd24e8a12b135114b559420f391b11d043ebd92a76d062774a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "044045d7e4da7bf14429553a96f0f4c58bc68c49a9c8da97e72c3606e0a9902f"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args, "--features", "apply,full"
  end

  test do
    (testpath/"test.csv").write("first header,second header")
    assert_equal <<~EOS, shell_output("#{bin}/qsv stats test.csv")
      field,type,sum,min,max,min_length,max_length,mean,stddev,variance,nullcount
      first header,NULL,,,,,,,,,0
      second header,NULL,,,,,,,,,0
    EOS
  end
end
