class Qsv < Formula
  desc "Ultra-fast CSV data-wrangling toolkit"
  homepage "https://github.com/jqnatividad/qsv"
  url "https://github.com/jqnatividad/qsv/archive/refs/tags/0.124.1.tar.gz"
  sha256 "53cc01abf04251a48df9b2237a65aa477cabaadb43359fde8260a213400ff920"
  license any_of: ["MIT", "Unlicense"]
  head "https://github.com/jqnatividad/qsv.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b4b7c34f49398c82e8405274ab91ae2806e8b7c59d16fb72b85c9d89f15b8d9e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f68811441940212093bbb8e760739b8436e712592f1ec2f88fe9f8aee071e55b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8b2217383a23b39e8523c8deb95625d277e4146160dc7289405050039d204bab"
    sha256 cellar: :any_skip_relocation, sonoma:         "356700f81bda224864db8474b8436e61c01f7b8b96099ca9b6eee9bb2638e6e8"
    sha256 cellar: :any_skip_relocation, ventura:        "ded565f147a4d03f19eeb4f430adc138f9c90e569859b9979ec9ad412e169968"
    sha256 cellar: :any_skip_relocation, monterey:       "e49312b2decd9dacf4a96650d83c2ee4a9b689173db4977694f829d4bee27b79"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5fc9abc12f492a3e6c3a9153d22b53b6390026b176c979a5c9f5f28a2e2c5023"
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
