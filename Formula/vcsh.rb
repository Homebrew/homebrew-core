class Vcsh < Formula
  desc "Config manager based on git"
  homepage "https://github.com/RichiH/vcsh"
  url "https://github.com/RichiH/vcsh/releases/download/v2.0.3/vcsh-2.0.3.tar.xz"
  sha256 "e772596111fb26750bc688d9c836fcd73770b1f24bad08b5ad23189666736204"
  license "GPL-2.0-or-later"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "c15597b5db9a80da494ae4bb693c0c409a05b7a8e32ccf70f268316593d8292d"
  end

  # Fix build failure with BSD `install`. Reported upstream at
  # https://github.com/RichiH/vcsh/issues/321
  patch :DATA

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

__END__
diff --git a/Makefile.in b/Makefile.in
index a58e41e..824b0f1 100644
--- a/Makefile.in
+++ b/Makefile.in
@@ -848,10 +848,12 @@ uninstall-man: uninstall-man1
 @IS_SDIST_FALSE@	$(RONN) < $< > $@
 
 completions/$(TRANSFORMED_PACKAGE_NAME): completions/vcsh.bash
-	install -D $< $@
+	mkdir -p $(dir $@)
+	install $< $@
 
 completions/_$(TRANSFORMED_PACKAGE_NAME): completions/vcsh.zsh
-	install -D $< $@
+	mkdir -p $(dir $@)
+	install $< $@
 
 .version: $(shell $(AWK) '{print ".git/" $$2}' .git/HEAD 2>/dev/null ||:)
 	[ -e "$@" ] && mv "$@" "$@-prev" || $(if $<,touch,cp "$(srcdir)/.tarball-version") "$@-prev"
