class Volta < Formula
  desc "JavaScript toolchain manager for reproducible environments"
  homepage "https://volta.sh"
  url "https://github.com/volta-cli/volta/archive/v1.0.8.tar.gz"
  sha256 "b6d1691424b13e28a953a2661e1f3261ecbeb607574ad217e18c4cf62ab48df4"
  license "BSD-2-Clause"
  head "https://github.com/volta-cli/volta.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "93ef1b6dc3561e5935cbf7645effa74022e3e51df7523f3d5478835ac2a960c2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4735a331c4535af9ca6b957faf09d668094269eb01908004182769ef860fe194"
    sha256 cellar: :any_skip_relocation, monterey:       "7908212da7ba34b9d006ded2bca7798a9d87eafcc2bd7a7d7ec651a91ba8d990"
    sha256 cellar: :any_skip_relocation, big_sur:        "12b612dea76ca6d73c76c90a1abd434ff80ebc8ffdedd9ee5982b8a0f4fbeb24"
    sha256 cellar: :any_skip_relocation, catalina:       "05e8f989a06a953bed701d3152933f9c1055ad10cc9a70f2412c1af8a2ce4bd5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "695e420e300d607a77cf956b80cd45bc924ad2ebfe839487601838006f667705"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "openssl@1.1" # Uses Secure Transport on macOS
  end

  def install
    system "cargo", "install", *std_cargo_args

    bash_output = Utils.safe_popen_read(bin/"volta", "completions", "bash")
    (bash_completion/"volta").write bash_output
    zsh_output = Utils.safe_popen_read(bin/"volta", "completions", "zsh")
    (zsh_completion/"_volta").write zsh_output
    fish_output = Utils.safe_popen_read(bin/"volta", "completions", "fish")
    (fish_completion/"volta.fish").write fish_output
  end

  test do
    system bin/"volta", "install", "node@12.16.1"
    node = shell_output("#{bin}/volta which node").chomp
    assert_match "12.16.1", shell_output("#{node} --version")
  end
end
