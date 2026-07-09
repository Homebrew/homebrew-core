class Scalaenv < Formula
  desc "Command-line tool to manage Scala environments"
  homepage "https://github.com/scalaenv/scalaenv"
  url "https://github.com/scalaenv/scalaenv/archive/refs/tags/version/0.1.14.tar.gz"
  sha256 "82adc5edd81f1914fae321deea36123bc4d3a255e47afa857cbd8b093903530c"
  license "MIT"
  head "https://github.com/scalaenv/scalaenv.git", branch: "master"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "14d04b14c8bdf554e6fd5482b937cf3fc21faba00487083d64a02d4d847de6ca"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "039eef152a101d05fde0923798a63bf7e04c5c96cb9d5b9cbe73011d9b5210de"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "53ad6b36416484fdf7290fadcd052918eb4f25275f3e89bb8338067403b81fab"
    sha256 cellar: :any_skip_relocation, sonoma:        "53ad6b36416484fdf7290fadcd052918eb4f25275f3e89bb8338067403b81fab"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "599f4f4d661d0e96068e4b84f256e0dd21a56e02d19edc4933e6ad20765ddf26"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "599f4f4d661d0e96068e4b84f256e0dd21a56e02d19edc4933e6ad20765ddf26"
  end

  def install
    inreplace "libexec/scalaenv", "/usr/local", HOMEBREW_PREFIX
    prefix.install "bin", "completions", "libexec"
    prefix.install "plugins" => "default-plugins"

    %w[scalaenv-install scalaenv-uninstall scala-build].each do |cmd|
      bin.install_symlink "#{prefix}/default-plugins/scala-install/bin/#{cmd}"
    end

    prefix.install_symlink (var/"lib/scalaenv/plugins").mkpath
    prefix.install_symlink (var/"lib/scalaenv/versions").mkpath
  end

  post_install_steps do
    ln_sf "default-plugins/scala-install", "lib/scalaenv/plugins/scala-install", target_base: :var
  end

  test do
    shell_output("eval \"$(#{bin}/scalaenv init -)\" && scalaenv versions")
  end
end
