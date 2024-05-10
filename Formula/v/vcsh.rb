class Vcsh < Formula
  desc "Config manager based on git"
  homepage "https://github.com/RichiH/vcsh"
  url "https://github.com/RichiH/vcsh/releases/download/v2.0.10/vcsh-2.0.10.tar.zst"
  sha256 "6ed8f4eee683f2cc8f885b31196fdc3b333f86ebc3110ecd1bcd60dfac64c0b4"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a2cd3d849d8d93364817eb4a01176c1938a3b9c5510e4fe38e0058449620f4a1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "66bec02ca7b95d794da587fbf0e1eabdfd5eb1f14b983dee39e1e7f0b2dbd893"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a2cd3d849d8d93364817eb4a01176c1938a3b9c5510e4fe38e0058449620f4a1"
    sha256 cellar: :any_skip_relocation, sonoma:         "a2cd3d849d8d93364817eb4a01176c1938a3b9c5510e4fe38e0058449620f4a1"
    sha256 cellar: :any_skip_relocation, ventura:        "a2cd3d849d8d93364817eb4a01176c1938a3b9c5510e4fe38e0058449620f4a1"
    sha256 cellar: :any_skip_relocation, monterey:       "a2cd3d849d8d93364817eb4a01176c1938a3b9c5510e4fe38e0058449620f4a1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a2cd3d849d8d93364817eb4a01176c1938a3b9c5510e4fe38e0058449620f4a1"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  def install
    # Set GIT, SED, and GREP to prevent
    # hardcoding shim references and absolute paths.
    # We set this even where we have no shims because
    # the hardcoded absolute path might not be portable.
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
