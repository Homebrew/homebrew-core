class Sbtenv < Formula
  desc "Command-line tool for managing sbt environments"
  homepage "https://github.com/sbtenv/sbtenv"
  url "https://github.com/sbtenv/sbtenv/archive/version/0.0.20.tar.gz"
  sha256 "b961314052a9c88dacb4f101dd1ac011a75d04e474353be20a4ae3bfcc39c56a"
  license "MIT"
  head "https://github.com/sbtenv/sbtenv.git"

  bottle :unneeded

  def install
    inreplace "libexec/sbtenv", "/usr/local", HOMEBREW_PREFIX
    prefix.install "bin", "completions", "libexec"
    prefix.install "plugins" => "default-plugins"

    %w[sbtenv-install].each do |cmd|
      bin.install_symlink "#{prefix}/default-plugins/sbt-install/bin/#{cmd}"
    end
  end

  def post_install
    var_lib = HOMEBREW_PREFIX/"var/lib/sbtenv"
    %w[plugins versions].each do |dir|
      var_dir = "#{var_lib}/#{dir}"
      mkdir_p var_dir
      ln_sf var_dir, "#{prefix}/#{dir}"
    end

    (var_lib/"plugins").install_symlink "#{prefix}/default-plugins/sbt-install"
  end

  test do
    shell_output("eval \"$(#{bin}/sbtenv init -)\" && sbtenv versions")
  end
end
