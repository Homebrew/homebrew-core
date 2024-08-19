class Qsv < Formula
  desc "Ultra-fast CSV data-wrangling toolkit"
  homepage "https://github.com/jqnatividad/qsv"
  url "https://github.com/jqnatividad/qsv/archive/refs/tags/0.131.1.tar.gz"
  sha256 "9038f09a0e1523bcf3a993bd95a36f8dd1c640e7ffbbe9404e018d41a7d82b66"
  license any_of: ["MIT", "Unlicense"]
  head "https://github.com/jqnatividad/qsv.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3bf43f86f4ea1c205bee4488f8f4ca8f75f52628204df1a6e4e2fd4c0ef79a94"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "054809865d1d89b1568716ae04cddc3ec383a5ad78a4446806726d253288057d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f0280090a51d6f3dd40faa41437792e99fc36d9603e083316e3abbf7b60f0faf"
    sha256 cellar: :any_skip_relocation, sonoma:         "cc259f3df9bfbb6622b073d786f45f8253132350111aa618778e6108976fb863"
    sha256 cellar: :any_skip_relocation, ventura:        "70f6e644f314f35bde182d04c52d8264b4985aad5136982bc27bc9f95af45370"
    sha256 cellar: :any_skip_relocation, monterey:       "273973961c5f651c4d810360d47d7ee2287ae76261ce7190dbe64ba8e631d315"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d1cef1b3f4322953bc679ae2e223dcf06cfd3616e7ec26b4312a4da62789eb73"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "libmagic"
  end

  def install
    system "cargo", "install", *std_cargo_args, "--features", "apply,luau,feature_capable"
    bash_completion.install "contrib/completions/examples/qsv.bash" => "qsv"
    fish_completion.install "contrib/completions/examples/qsv.fish"
    zsh_completion.install "contrib/completions/examples/qsv.zsh" => "_qsv"
  end

  test do
    (testpath/"test.csv").write("first header,second header")
    assert_equal <<~EOS, shell_output("#{bin}/qsv stats test.csv")
      field,type,is_ascii,sum,min,max,range,min_length,max_length,mean,sem,stddev,variance,cv,nullcount,max_precision,sparsity
      first header,NULL,,,,,,,,,,,,,0,,
      second header,NULL,,,,,,,,,,,,,0,,
    EOS
  end
end
