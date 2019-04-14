class Volt < Formula
  desc "Meta-level vim package manager"
  homepage "https://github.com/vim-volt/volt"
  url "https://github.com/vim-volt/volt.git",
    :tag      => "v0.3.5a",
    :revision => "dd1a16c77faf9887408744b146efc2d0bfdf500c"
  head "https://github.com/vim-volt/volt.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "bef81710d05a2defe04b4890f5ac9a8dd42c143994756b72e6ab7ceaa30e08e6" => :mojave
    sha256 "cfe9f4dd24c96516de480a5d498b93f7b94740284b2ffb59219c5d632b915ad5" => :high_sierra
    sha256 "b503cbf438b2e4ec9f72339672970fd92ead4a74965b0f5ffb6ca8120cdf71d7" => :sierra
  end

  depends_on "go" => :build

  def install
    mkdir_p buildpath/"src/github.com/vim-volt"
    ln_s buildpath, buildpath/"src/github.com/vim-volt/volt"
    ENV["GOPATH"] = buildpath

    system "make", "BIN_DIR=#{bin}"

    bash_completion.install "_contrib/completion/bash" => "volt"
  end

  test do
    mkdir_p testpath/"volt/repos/localhost/foo/bar/plugin"
    File.write(testpath/"volt/repos/localhost/foo/bar/plugin/baz.vim", "qux")
    system bin/"volt", "get", "localhost/foo/bar"
    assert_equal File.read(testpath/".vim/pack/volt/opt/localhost_foo_bar/plugin/baz.vim"), "qux"
  end
end
