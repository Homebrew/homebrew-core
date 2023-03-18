class Rtx < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://github.com/jdxcode/rtx"
  url "https://github.com/jdxcode/rtx/archive/refs/tags/v1.25.4.tar.gz"
  sha256 "5a7ebcfee1b38302cd2b2a33245a1d2f7fb91257bc28134296cb3247271b4846"
  license "MIT"
  head "https://github.com/jdxcode/rtx.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c58b89e1d2f4754fa6ca989f8ad8e7f359b46b630b664dcee02dbe2379317b02"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "13bd79a536b2a450191bd4e1896543790ecdeffe8a816ab0656a1e309ce3c177"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e4612dcda3eefb66e54d628f18435d3dff4c68f467f343bb8e1ae17078090b46"
    sha256 cellar: :any_skip_relocation, ventura:        "119976a26863b628ebe46770a30f65f8d0f5941212e434b18f7050db20cd69ab"
    sha256 cellar: :any_skip_relocation, monterey:       "4218a8c95c011b1b62e84c8ac92bf0447fb10781884b8850faec742f70cc74db"
    sha256 cellar: :any_skip_relocation, big_sur:        "b192576fcf51fc89b6ec2cc2a891562123e7c60f8270d837fbfc0aa96384c605"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e62c84d5b3a03a8a1908527561977c69f1afd386f3fa0c430953ed25aced96a9"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--features=brew", *std_cargo_args
    man1.install "man/man1/rtx.1"
    generate_completions_from_executable(bin/"rtx", "complete", "--shell")
  end

  test do
    system "#{bin}/rtx", "install", "nodejs@18.13.0"
    assert_match "v18.13.0", shell_output("#{bin}/rtx exec nodejs@18.13.0 -- node -v")
  end
end
