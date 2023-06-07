class Qsv < Formula
  desc "Ultra-fast CSV data-wrangling toolkit"
  homepage "https://github.com/jqnatividad/qsv"
  url "https://github.com/jqnatividad/qsv/archive/refs/tags/0.105.1.tar.gz"
  sha256 "c33d430015ff54619bff852570f1add4586fe25a6d18d0414a9c51a4a5e22781"
  license any_of: ["MIT", "Unlicense"]
  head "https://github.com/jqnatividad/qsv.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fede50c182f12a52a91be5dd45e8cb76ca04cf3d9ac97673def10c656f6eef08"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8a2d069651671b259043b2f47d69511069636a8695616c44986cce97f8d27bab"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d468ddef2385e04aa09dbc65a00780225720d683e74532df0c836210a466164b"
    sha256 cellar: :any_skip_relocation, ventura:        "25dd2bea62e98255afeaabf62796179af04a3d709cb1c345c82714a682ab0561"
    sha256 cellar: :any_skip_relocation, monterey:       "98212fea4cf9ead4ea16a034f38243c612f5cc5863d41ec18eea063f3db93b45"
    sha256 cellar: :any_skip_relocation, big_sur:        "f61efef7ac446225d86a3b4025f7ccf26dd07f851020185377b1d29fd1e5524b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "403b2f560742b660ff395eee80bfc2119808080056dd7d191bd3701a31fb23a2"
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
