class Qsv < Formula
  desc "Ultra-fast CSV data-wrangling toolkit"
  homepage "https://github.com/jqnatividad/qsv"
  url "https://github.com/jqnatividad/qsv/archive/refs/tags/0.127.0.tar.gz"
  sha256 "1accc3d8d0954a83bbffc34530151bb8b7b0549afe01d6157d3a6d4e4edacfcb"
  license any_of: ["MIT", "Unlicense"]
  head "https://github.com/jqnatividad/qsv.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ecabe08d2ee9cf5f499c7ec5c6aacbff850002026a6749f8a052c09e75823972"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "08ad91c1040f514b7ff51a26df096fc4a8fbddd74c8f37d43bccb98327a21004"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b3f262bf8403ca2ea92ae6ccc7a77c4f61befe6f6bf60a5d0cd061f0cbec7ee3"
    sha256 cellar: :any_skip_relocation, sonoma:         "79c31a38fd17bc8f52245e21eebcd00412c71c52d66b42daa1d05a63f67bea4a"
    sha256 cellar: :any_skip_relocation, ventura:        "85585ac128e2015aa6e80fd6ba1a4ee1bbf1737469cfed85ca49397bb241a41b"
    sha256 cellar: :any_skip_relocation, monterey:       "d8840ec34fc38265e445f7e957b59934d739c1b047ed2c4f822fa7999756f0e7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c6d086a58cd5a34910f9667ac9e988cbbc2a2e658a50597d22eb0741576a654d"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "libmagic"
  end

  def install
    system "cargo", "install", *std_cargo_args, "--features", "apply,luau,feature_capable"
  end

  test do
    (testpath/"test.csv").write("first header,second header")
    assert_equal <<~EOS, shell_output("#{bin}/qsv stats test.csv")
      field,type,sum,min,max,range,min_length,max_length,mean,stddev,variance,nullcount,sparsity
      first header,NULL,,,,,,,,,,0,
      second header,NULL,,,,,,,,,,0,
    EOS
  end
end
