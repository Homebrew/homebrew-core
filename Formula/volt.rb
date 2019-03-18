class Volt < Formula
  desc "Meta-level vim package manager"
  homepage "https://github.com/vim-volt/volt"
  url "https://github.com/vim-volt/volt.git",
    :tag      => "v0.3.5a",
    :revision => "dd1a16c77faf9887408744b146efc2d0bfdf500c"
  head "https://github.com/vim-volt/volt.git"

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
