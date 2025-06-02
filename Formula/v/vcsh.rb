class Vcsh < Formula
  desc "Config manager based on git"
  homepage "https://github.com/RichiH/vcsh"
  url "https://github.com/RichiH/vcsh/releases/download/v2.0.10/vcsh-2.0.10.tar.zst"
  sha256 "6ed8f4eee683f2cc8f885b31196fdc3b333f86ebc3110ecd1bcd60dfac64c0b4"
  license "GPL-2.0-or-later"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "3184a9cba5e9b79532e01e2fa7b24478918585c55bed898b0eaed6886390d456"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build

  def install
    system "autoreconf", "--force", "--install", "--verbose"
    # Set GIT, SED, and GREP to prevent
    # hardcoding shim references and absolute paths.
    # We set this even where we have no shims because
    # the hardcoded absolute path might not be portable.
    system "./configure", "--without-zsh-completion-dir",
                          "--without-bash-completion-dir",
                          "GIT=git", "SED=sed", "GREP=grep",
                          *std_configure_args
    system "make", "install"

    # Make the shebang uniform across macOS and Linux
    inreplace bin/"vcsh", %r{^#!/bin/(ba)?sh$}, "#!/usr/bin/env bash"
    bash_completion.install "completions/vcsh.bash" => "vcsh"
    zsh_completion.install "completions/vcsh.zsh" => "_vcsh"
  end

  test do
    assert_match "Initialized empty", shell_output("#{bin}/vcsh init test").strip
  end
end
