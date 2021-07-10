class ValaLanguageServer < Formula
  desc "Code Intelligence for Vala & Genie"
  homepage "https://github.com/Prince781/vala-language-server"
  url "https://github.com/Prince781/vala-language-server/archive/3e01b8383b3db3c39af276528663d6084c671455.tar.gz"
  version "0.48.3"
  sha256 "6f3b34bcb4e049c299ae3d5433153e4b685b0bace0ea8d761ffea266714ce841"
  license "LGPL-2.1-only"

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "vala" => :build
  depends_on "glib"
  depends_on "json-glib"
  depends_on "jsonrpc-glib"
  depends_on "libgee"

  def install
    system "meson", "-Dplugins=false", "-Dprefix=#{prefix}", "build"
    system "ninja", "-C", "build"
    system "ninja", "-C", "build", "install"
  end

  test do
    # There are currently no tests for VLS
    # (https://github.com/Prince781/vala-language-server/issues/26)
    # I'll edit this section when there are some
    # For now, I'm just checking to see if the project description is printed in help
    assert_match(/A language server for Vala/, shell_output("#{bin}/vala-language-server -h"))
  end
end
