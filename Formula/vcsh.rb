class Vcsh < Formula
  desc "Config manager based on git"
  homepage "https://github.com/RichiH/vcsh"
  url "https://github.com/RichiH/vcsh/releases/download/v2.0.4/vcsh-2.0.4.tar.xz"
  sha256 "5bf425d89f474c340fbb47a5df8987573a9ef3928658b3e9876b07cae1333cf2"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "a10034412763e8523978a3223825e125f85958ec4546a7b311b8a7f748d74c1e"
  end

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
