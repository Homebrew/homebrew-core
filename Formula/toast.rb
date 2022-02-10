class Toast < Formula
  desc "Tool for running tasks in containers"
  homepage "https://github.com/stepchowfun/toast"
  url "https://github.com/stepchowfun/toast/archive/v0.45.3.tar.gz"
  sha256 "0c6d1e7ecf0de3ed0647fcae040c8dd318a62604f22fb011301c2d3b69c2d439"
  license "MIT"
  head "https://github.com/stepchowfun/toast.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "97161beba2abc503bc51f59c411ed9f86bd84edca8cdc04d40e514cf58249dca"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "245c20fd184e13be021424cc410ff4e7e406811aced31708bd96043648a8b20e"
    sha256 cellar: :any_skip_relocation, monterey:       "1a14c3fc0f142010dda00b10e87cb540195101cf7a87645787fafd41998852e2"
    sha256 cellar: :any_skip_relocation, big_sur:        "079c6bf9e5dca0b1c8e472f36852946c083f0a37a0bcb3694d83c0eed562c410"
    sha256 cellar: :any_skip_relocation, catalina:       "300b34eb3f9a1aa01dc7264301a35a061575016b80b1d103b768e21eb86406fa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c588647d27171b86a3515943a9bd473f841057262d748f840c8b3c2f45889212"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"toast.yml").write <<~EOS
      image: alpine
      tasks:
        homebrew_test:
          description: brewtest
          command: echo hello
    EOS

    assert_match "homebrew_test", shell_output("#{bin}/toast --list")
  end
end
