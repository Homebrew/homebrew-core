class Vis < Formula
  desc "Vim-like text editor"
  homepage "https://github.com/martanne/vis"
  url "https://github.com/martanne/vis/archive/v0.2.tar.gz"
  sha256 "3e5b81d760849c56ee378421e9ba0f653c641bf78e7594f71d85357be99a752d"

  head "https://github.com/martanne/vis.git"

  depends_on "lua" => :recommended
  depends_on "lpeg" => :lua
  depends_on "libtermkey"

  def script; <<-EOS.undent
    #!/bin/sh
    VIS_BASE=`brew --prefix vis`/libexec
    VIS_PATH=$VIS_BASE/share/vis $VIS_BASE/bin/vis $@
    EOS
  end

  def install
    system "./configure", "--prefix=#{libexec}"
    system "make", "install"
    (bin/"vise").write script
  end

  def caveats; <<-EOS.undent
    To avoid a name conflict with the OS X system utility /usr/bin/vis,
    this text editor must be invoked by calling `vise` ("vis-editor").
  EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/vise -v 2>&1", 1)
  end
end
