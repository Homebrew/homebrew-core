class Toast < Formula
  desc "Tool for running tasks in containers"
  homepage "https://github.com/stepchowfun/toast"
  url "https://github.com/stepchowfun/toast/archive/v0.41.0.tar.gz"
  sha256 "ff890c4d1b911d0fc8c803de44c40e8cffdcdf7a477752c2f253445f934e5a38"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "0f8e5e72fbcf0d4cf9f7f6802c5830d349e0c6097708cde29031c918da8ec947"
    sha256 cellar: :any_skip_relocation, big_sur:       "3d743030f31ee5c74dadde0da038afcc26db559a12caa6310fcf632544de090f"
    sha256 cellar: :any_skip_relocation, catalina:      "be9b92f2c9d8c5aef19ea21144179308fe176eb8c2c7da8e1fbfaa33dacab8de"
    sha256 cellar: :any_skip_relocation, mojave:        "35cb012a2dada83cf0d99c2a24923155e0c0dc3b6da4db01d47229a673f50ee1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3da5a9de3222c320dee014a10f7cd957dca64dc28b0f87106c4326f3d279a1c6"
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
