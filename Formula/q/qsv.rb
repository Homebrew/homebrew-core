class Qsv < Formula
  desc "Ultra-fast CSV data-wrangling toolkit"
  homepage "https://github.com/jqnatividad/qsv"
  url "https://github.com/jqnatividad/qsv/archive/refs/tags/0.124.0.tar.gz"
  sha256 "9cf90baa886fa349e800851fffec5bccf3d491211119ac08a9a9f4180b244280"
  license any_of: ["MIT", "Unlicense"]
  head "https://github.com/jqnatividad/qsv.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "81c29e16a21042d96426964018f98483038b9da101b842dbed7ae087d4e059a7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1f0e3f669f64171fc9a3be2a57ed73a784541cb5fff0eefbc209459519461733"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f7b8c9dd6c548e46039665677186f526517db73e219228f9961b6a4b12346a21"
    sha256 cellar: :any_skip_relocation, sonoma:         "e7e27dd471da89c38a9c5ed07c02d3d38bcc3f6710389e77621d01bdb94a1e81"
    sha256 cellar: :any_skip_relocation, ventura:        "c0475a44dab34e8d055f77ca5edbe241f36c396f0e21cd92be9236f4b75ab4d7"
    sha256 cellar: :any_skip_relocation, monterey:       "f706de437232baf99f198cf9e6d421d0d86f868dbc731e00d94c2d1b10068fb3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cb774f87f275ce932c24deca9a2f2669a184440546c780972d3b85bb6b980488"
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
