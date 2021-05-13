class Scalaenv < Formula
  desc "Command-line tool to manage Scala environments"
  homepage "https://github.com/scalaenv/scalaenv"
  url "https://github.com/scalaenv/scalaenv/archive/refs/tags/version/0.1.12.tar.gz"
  sha256 "056f85803997aa256c3d2915ce5407d0774de6efdb8703770fcdfa746ca4125d"
  license "MIT"
  head "https://github.com/scalaenv/scalaenv.git"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "ce5b172105ba10119874ab9ebc388c1971976133ec475c58cc7b6895a3f59268"
  end

  def install
    inreplace "libexec/scalaenv", "/usr/local", HOMEBREW_PREFIX
    prefix.install "bin", "completions", "libexec"
    prefix.install "plugins" => "default-plugins"

    %w[scalaenv-install scalaenv-uninstall scala-build].each do |cmd|
      bin.install_symlink "#{prefix}/default-plugins/scala-install/bin/#{cmd}"
    end
  end

  def post_install
    var_lib = HOMEBREW_PREFIX/"var/lib/scalaenv"
    %w[plugins versions].each do |dir|
      var_dir = "#{var_lib}/#{dir}"
      mkdir_p var_dir
      ln_sf var_dir, "#{prefix}/#{dir}"
    end

    (var_lib/"plugins").install_symlink "#{prefix}/default-plugins/scala-install"
  end

  test do
    shell_output("eval \"$(#{bin}/scalaenv init -)\" && scalaenv versions")
  end
end
