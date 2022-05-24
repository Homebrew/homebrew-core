class Volt < Formula
  desc "Meta-level vim package manager"
  homepage "https://github.com/vim-volt/volt"
  url "https://github.com/vim-volt/volt.git",
      tag:      "v0.3.7",
      revision: "e604467d8b440c89793b2e113cd241915e431bf9"
  head "https://github.com/vim-volt/volt.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "87cfdbc43edeb2cedc60ddda401062cad644f0fa6d799d7ef112800984a10da7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "836f10188a9b461531bac4b6eb803e4f86057342e443df99c0c466e224af18b6"
    sha256 cellar: :any_skip_relocation, monterey:       "d7d07259218a768843d6c9131e6e9f616e242b50f01aacbbdb9f539960cbcf77"
    sha256 cellar: :any_skip_relocation, big_sur:        "f08427b7e8f71b984417f65a5154dde9883610fb683891e16e267928c578bd59"
    sha256 cellar: :any_skip_relocation, catalina:       "60210297f62f908ef4090a7f69631ad02cb4fe2ce8472e953f67ad91caa9461c"
    sha256 cellar: :any_skip_relocation, mojave:         "9db9e940c124e8e655cdd84b7d143f526535c588ebd6503acb3960143d08f905"
    sha256 cellar: :any_skip_relocation, high_sierra:    "7fd8887efcdc3a9816b2dea510c2e3ba218e0e719390841d3b0b416fde53378e"
    sha256 cellar: :any_skip_relocation, sierra:         "4edc3f1130757ddbf0a7b3c018825f68f2ecb24417f3afc3fd54b532e8c72c46"
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
    system "go", "build", "-ldflags", "-s -w", "-trimpath", "-o", bin/"volt"
    prefix.install_metafiles

    bash_completion.install "_contrib/completion/bash" => "volt"
    zsh_completion.install "_contrib/completion/zsh" => "_volt"
    cp "#{bash_completion}/volt", "#{zsh_completion}/volt-completion.bash"
  end

  test do
    mkdir_p testpath/"volt/repos/localhost/foo/bar/plugin"
    File.write(testpath/"volt/repos/localhost/foo/bar/plugin/baz.vim", "qux")
    system bin/"volt", "get", "localhost/foo/bar"
    assert_equal File.read(testpath/".vim/pack/volt/opt/localhost_foo_bar/plugin/baz.vim"), "qux"
  end
end
