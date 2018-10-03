class Um < Formula
  desc "Command-line utility for creating and maintaining personal man pages"
  homepage "https://github.com/sinclairtarget/um"
  url "https://github.com/sinclairtarget/um/archive/4.0.0.tar.gz"
  sha256 "bfcf9906faaddeb831baf3c98120989eb79f3a07b288f0fe3b605634fe1658ad"

  bottle :unneeded
  depends_on "ruby"

  resource "kramdown" do
    url "https://rubygems.org/gems/kramdown-1.17.0.gem"
    sha256 "5862410a2c1692fde2fcc86d78d2265777c22bd101f11c76442f1698ab242cd8"
  end

  def install
    bash_completion.install "um-completion.sh"
    man1.install Dir["doc/man1/*"]

    prefix.install Dir["*"]

    resource("kramdown").stage do |context|
      system("gem", "install", context.resource.cached_download,
             "--no-document", "--install-dir", "#{lib}/um/vendor")
    end

    (bin/"um").write(exec_script)
    (prefix/"version.txt").write(version)
  end

  def exec_script
    <<~EOS
      #! /bin/bash
      export GEM_HOME="#{HOMEBREW_PREFIX}/lib/um/vendor"
      exec ruby "#{libexec}/um.rb" "$@"
    EOS
  end

  test do
    shell_output("#{bin}/um version")
  end
end
