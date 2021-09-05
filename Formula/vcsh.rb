class Vcsh < Formula
  desc "Config manager based on git"
  homepage "https://github.com/RichiH/vcsh"
  url "https://github.com/RichiH/vcsh/releases/download/v2.0.2/vcsh-2.0.2.tar.xz"
  sha256 "3ffc0bbb43c76620c8234c98f4ae94d0a99d24bb240497aab730979a8d23ad61"
  license "GPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "1cea2a03ee37da016d37fed26f2d5b2a0f83925283ca56d8e79492d7202e4c39"
    sha256 cellar: :any_skip_relocation, big_sur:       "1cea2a03ee37da016d37fed26f2d5b2a0f83925283ca56d8e79492d7202e4c39"
    sha256 cellar: :any_skip_relocation, catalina:      "1cea2a03ee37da016d37fed26f2d5b2a0f83925283ca56d8e79492d7202e4c39"
    sha256 cellar: :any_skip_relocation, mojave:        "1cea2a03ee37da016d37fed26f2d5b2a0f83925283ca56d8e79492d7202e4c39"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "745592d712de7d72f0b4490f8c6253168b15b920e760959120a4fc85daa3072e"
  end

  def install
    # Set GIT, SED, and GREP to prevent
    # hardcoding shim references and absolute paths
    system "./configure", "--with-zsh-completion-dir=#{zsh_completion}",
                          "--with-bash-completion-dir=#{bash_completion}",
                          "GIT=git", "SED=sed", "GREP=grep",
                          *std_configure_args
    system "make", "install"

    # Make the shebang uniform across macOS and Linux
    inreplace bin/"vcsh", %r{^#!/bin/(ba)?sh$}, "#!/usr/bin/env bash"
  end

  test do
    assert_match "Initialized empty", shell_output("#{bin}/vcsh init test").strip
  end
end
