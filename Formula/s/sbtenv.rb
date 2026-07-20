class Sbtenv < Formula
  desc "Command-line tool for managing sbt environments"
  homepage "https://github.com/sbtenv/sbtenv"
  url "https://github.com/sbtenv/sbtenv/archive/refs/tags/version/0.0.24.tar.gz"
  sha256 "f483769e5467c718c9de72baa4eb3c679315e4f4a9ac02bb636996a63c28e3d5"
  license "MIT"
  head "https://github.com/sbtenv/sbtenv.git", branch: "master"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "16ab8bbf880ca983c16aa42dbf63b695ba03e874542ce9aa38dee1adad68a80c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a7dad9deea7c992f38474ddc585024e80e95fcc8a0b9a81e35672a2f584a11bc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "42b78f776c9ed31932c1e2f922c925787c5d91effabee33586db265c76e9316c"
    sha256 cellar: :any_skip_relocation, sonoma:        "42b78f776c9ed31932c1e2f922c925787c5d91effabee33586db265c76e9316c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b399cf204ab561ad58a7474bc27bcbe850ddd26ae94fca36f394744a294d6ef1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b399cf204ab561ad58a7474bc27bcbe850ddd26ae94fca36f394744a294d6ef1"
  end

  def install
    inreplace "libexec/sbtenv", "/usr/local", HOMEBREW_PREFIX
    prefix.install "bin", "completions", "libexec"
    prefix.install "plugins" => "default-plugins"

    bin.install_symlink prefix/"default-plugins/sbt-install/bin/sbtenv-install"
    prefix.install_symlink (var/"lib/sbtenv/plugins").mkpath
    prefix.install_symlink (var/"lib/sbtenv/versions").mkpath
  end

  # Var symlinks must be done in post install as bottling converts symlinks to real files
  post_install_steps do
    symlink "default-plugins/sbt-install", "lib/sbtenv/plugins/sbt-install", target_base: :var, overwrite: true
  end

  test do
    shell_output("eval \"$(#{bin}/sbtenv init -)\" && sbtenv versions")
  end
end
