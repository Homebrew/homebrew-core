class Savana < Formula
  desc "Transactional workspaces for SVN"
  homepage "https://github.com/codehaus/savana"
  url "https://bintray.com/artifact/download/bintray/jcenter/org/codehaus/savana/1.2/savana-1.2-install.tar.gz"
  sha256 "608242a0399be44f41ff324d40e82104b3c62908bc35177f433dcfc5b0c9bf55"
  license "LGPL-3.0"

  depends_on "openjdk"

  def install
    # Remove Windows files
    rm_rf Dir["bin/*.{bat,cmd}"]

    prefix.install %w[COPYING COPYING.LESSER licenses svn-hooks]

    # lib/* and logging.properties are loaded relative to bin
    prefix.install "bin"
    libexec.install %w[lib logging.properties]
    bin.env_script_all_files libexec/"bin", JAVA_HOME: Formula["openjdk"].opt_prefix

    bash_completion.install "etc/bash_completion" => "savana-completion.bash"
  end

  test do
    system "#{bin}/sav", "help"
  end
end
