class Savana < Formula
  desc "Transactional workspaces for SVN"
  homepage "https://github.com/codehaus/savana"
  url "https://search.maven.org/remotecontent?filepath=org/codehaus/savana/1.2/savana-1.2-install.tar.gz"
  sha256 "608242a0399be44f41ff324d40e82104b3c62908bc35177f433dcfc5b0c9bf55"
  license "LGPL-3.0-or-later"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, all: "def842802d985d741c12f61a00788780ada018db5837b585f2c58540109339e2"
  end

  depends_on "openjdk"

  def install
    # Remove Windows files
    rm_r(Dir["bin/*.{bat,cmd}"])

    prefix.install %w[COPYING COPYING.LESSER licenses svn-hooks]

    # lib/* and logging.properties are loaded relative to bin
    prefix.install "bin"
    libexec.install %w[lib logging.properties]
    bin.env_script_all_files libexec/"bin", JAVA_HOME: Formula["openjdk"].opt_prefix

    bash_completion.install "etc/bash_completion" => "sav"
  end

  test do
    system bin/"sav", "help"
  end
end
