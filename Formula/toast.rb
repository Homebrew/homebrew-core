class Toast < Formula
  desc "Tool for running tasks in containers"
  homepage "https://github.com/stepchowfun/toast"
  url "https://github.com/stepchowfun/toast/archive/v0.45.3.tar.gz"
  sha256 "0c6d1e7ecf0de3ed0647fcae040c8dd318a62604f22fb011301c2d3b69c2d439"
  license "MIT"
  head "https://github.com/stepchowfun/toast.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b3f0b77e9663d70113d8e0becb4a903dea8d595dd4b3fb02d61b2c41bdb7f663"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3aaf8836c0001e1429c7817f3cf8f208f2a7a584102b1acf9a30bd9794a5051a"
    sha256 cellar: :any_skip_relocation, monterey:       "6275857412a9e28c5764ca4bce2ec3bc77ccb58cea7244e382687b7320e929d1"
    sha256 cellar: :any_skip_relocation, big_sur:        "2d027110d8038ff6fcbf30998685feb3f0ba71725e7f11d0ab6843c22ebfa72e"
    sha256 cellar: :any_skip_relocation, catalina:       "8b1d74fc3dd8ed48cd83f88ddc7efb7492a72066a877b59181c793c629922a0c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c4adacd55b9b2fa0879209ea4a893e00276093b62a5c97d57e0a58c005277a0d"
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
