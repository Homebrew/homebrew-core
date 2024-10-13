class Vis < Formula
  desc "Vim-like text editor"
  homepage "https://github.com/martanne/vis"
  url "https://github.com/martanne/vis/archive/refs/tags/v0.9.tar.gz"
  sha256 "bd37ffba5535e665c1e883c25ba5f4e3307569b6d392c60f3c7d5dedd2efcfca"
  license "ISC"
  head "https://github.com/martanne/vis.git", branch: "master"

  bottle do
    sha256 arm64_sequoia:  "6edc0624be797ed3bbee95686dd3af6f164c24e95d520b809004f12518d02553"
    sha256 arm64_sonoma:   "04a4e8d45b5442ffb3397012eccde1c747b249ae42e8468b24d557dd15ea6081"
    sha256 arm64_ventura:  "ce1c6d2521a9ab11b32316850690289887a739b2b88a9809b1678682b586fc26"
    sha256 arm64_monterey: "aeb76e19c965bce4434207059279cae63e30be3e51e933bee8ff52f579b8035d"
    sha256 sonoma:         "77bfde98fc76bf93d057923482bd1e9b3d538ef8c3875f4b9b579a63cbb75d22"
    sha256 ventura:        "b27829afe0c6cbb2792f3340ac3605caa16c68677764a1c586879f5387064ca4"
    sha256 monterey:       "30d9272d1e6e00b8b87c61157e157df124a32c265d4f8befc52df8ac8e2545fb"
    sha256 x86_64_linux:   "6f7e0f61479a8c931556361f8c0dd42a913211ddff0a8b8dfb6b2240f6fb2c6b"
  end

  depends_on "pkg-config" => :build
  depends_on "libtermkey"
  depends_on "lpeg"
  depends_on "lua"

  uses_from_macos "unzip" => :build
  uses_from_macos "ncurses"

  def install
    system "./configure", "--enable-lua", "--enable-lpeg-static=no", *std_configure_args
    system "make", "install"

    return unless OS.mac?

    # Rename vis & the matching manpage to avoid clashing with the system.
    mv bin/"vis", bin/"vise"
    mv man1/"vis.1", man1/"vise.1"
  end

  def caveats
    on_macos do
      <<~EOS
        To avoid a name conflict with the macOS system utility /usr/bin/vis,
        this text editor must be invoked by calling `vise` ("vis-editor").
      EOS
    end
  end

  test do
    binary = if OS.mac?
      bin/"vise"
    else
      bin/"vis"
    end

    assert_match "vis #{version} +curses +lua", shell_output("#{binary} -v 2>&1")
  end
end
