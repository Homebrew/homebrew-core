class Scalaenv < Formula
  desc "Command-line tool to manage Scala environments"
  homepage "https://github.com/mazgi/scalaenv"
  url "https://github.com/mazgi/scalaenv/archive/version/0.0.12.tar.gz"
  sha256 "cc6f095c7a76623437030720fc49f786f1711be7c8418b2d4bc27ecec150d5dc"
  head "https://github.com/mazgi/scalaenv.git"

  bottle :unneeded

  def install
    inreplace "libexec/scalaenv", "/usr/local", HOMEBREW_PREFIX
    prefix.install "bin", "completions", "libexec"
    prefix.install "plugins" => "default-plugins"

    %w[scalaenv-install].each do |cmd|
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
