class Volt < Formula
  desc "Meta-level vim package manager"
  homepage "https://github.com/vim-volt/volt"
  url "https://github.com/vim-volt/volt/archive/refs/tags/v0.3.7.tar.gz"
  sha256 "db64e9a04426d2b1c0873e1ffd7a4c2d0f1ffe61688bee670bb16089b9c98639"
  license "MIT"
  head "https://github.com/vim-volt/volt.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "fbaafd3e4142b6c23f3e24eb068fd5a88beb6606e19b5b2cc9f7c6bda6ebc707"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "6a7d8d94a9503960278ce6a43f2cf5ce58658d04d06b72be99804a9e0d52f901"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9dd1f6abf67c665ee109373b87fed3c705902f2b5fddc68bc7c2dfaec0194c73"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "59485100787529576ed3a8c6b89aaa86fe1efb46854d39e5b5952769c96d258d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "87cfdbc43edeb2cedc60ddda401062cad644f0fa6d799d7ef112800984a10da7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "836f10188a9b461531bac4b6eb803e4f86057342e443df99c0c466e224af18b6"
    sha256 cellar: :any_skip_relocation, sonoma:         "8f36e0949fd1b874327a78d1fad51791f7f2349b4dfa964c9774b2bb338e386f"
    sha256 cellar: :any_skip_relocation, ventura:        "c5244e0342f754911a266ba1fa595c9ef9eb14b19e9191f325ff484551be9297"
    sha256 cellar: :any_skip_relocation, monterey:       "d7d07259218a768843d6c9131e6e9f616e242b50f01aacbbdb9f539960cbcf77"
    sha256 cellar: :any_skip_relocation, big_sur:        "f08427b7e8f71b984417f65a5154dde9883610fb683891e16e267928c578bd59"
    sha256 cellar: :any_skip_relocation, catalina:       "60210297f62f908ef4090a7f69631ad02cb4fe2ce8472e953f67ad91caa9461c"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "5d73df7f1d4f25fcf52a63390fb88fc5416df7c599556ea2f90f38f6a3151c5d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fe7d78905a357fa59f18330aab57269cce1fda6af521552918d54911fd075035"
  end

  depends_on "go" => :build

  uses_from_macos "vim" => :test

  # Go 1.14+ compatibility.
  patch do
    url "https://github.com/vim-volt/volt/commit/aa9586901d249aa40e67bc0b3e0e7d4f13d5a88b.patch?full_index=1"
    sha256 "62bed17b5c58198f44a669e41112335928e2fa93d71554aa6bddc782cf124872"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    bash_completion.install "_contrib/completion/bash" => "volt"
    zsh_completion.install "_contrib/completion/zsh" => "_volt"
    cp bash_completion/"volt", zsh_completion/"volt-completion.bash"
  end

  test do
    (testpath/"volt/repos/localhost/foo/bar/plugin/baz.vim").write "qux"
    system bin/"volt", "get", "localhost/foo/bar"
    assert_equal "qux", (testpath/".vim/pack/volt/opt/localhost_foo_bar/plugin/baz.vim").read
  end
end
