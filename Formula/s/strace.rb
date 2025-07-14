class Strace < Formula
  desc "Diagnostic, instructional, and debugging tool for the Linux kernel"
  homepage "https://strace.io/"
  url "https://github.com/strace/strace/releases/download/v6.15/strace-6.15.tar.xz"
  sha256 "8552dfab08abc22a0f2048c98fd9541fd4d71b6882507952780dab7c7c512f51"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_linux:  "81705c55fef29e04e09f7b96c5317ea7910f0f047ba141cd6ba6f712fc21318a"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "17b03a29b9a77243ebcc24ce394fd1b6e072e868f6247e46e6af5ad184c0b809"
  end

  head do
    url "https://github.com/strace/strace.git", branch: "master"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on :linux

  def install
    system "./bootstrap" if build.head?
    system "./configure", "--disable-silent-rules",
                          "--enable-mpers=no", # FIX: configure: error: Cannot enable m32 personality support
                          *std_configure_args.reject { |s| s["--disable-debug"] }
    system "make", "install"
  end

  test do
    out = `"strace" "true" 2>&1` # strace the true command, redirect stderr to output
    assert_match "execve(", out
    assert_match "+++ exited with 0 +++", out
  end
end
