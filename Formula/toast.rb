class Toast < Formula
  desc "Tool for running tasks in containers"
  homepage "https://github.com/stepchowfun/toast"
  url "https://github.com/stepchowfun/toast/archive/v0.39.0.tar.gz"
  sha256 "0794eaa10790e15d82d72f9f763be2a1a47097b5dd785c025b1846615bbaec73"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "a8cf7712f0996b7fe116afb208e874fd14da2fd6f0651052d2b5b77894b5901b"
    sha256 cellar: :any_skip_relocation, big_sur:       "63f32de44e88fbc8ec7baa8e801767f012f5cef9c7e83d233073346c6f883dcd"
    sha256 cellar: :any_skip_relocation, catalina:      "79a4129a24fa78a863eb5ef9e759cc8dc2f2014b6d3021ab1f690897b24c80c1"
    sha256 cellar: :any_skip_relocation, mojave:        "3fe5fafd1c5fb50a30996c7779ebc53c5cd3ad588c3fd49a58447ba8063e4519"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fc111f146a51adf74960ab1da9700952bf6568b2bd10d143bebbb8c1a43cbf15"
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
          command: echo hello
    EOS

    assert_match "homebrew_test", shell_output("#{bin}/toast --list")
  end
end
