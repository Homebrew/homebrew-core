class Zinc < Formula
  desc "Stand-alone version of sbt's Scala incremental compiler"
  homepage "https://github.com/typesafehub/zinc"
  url "https://downloads.typesafe.com/zinc/0.3.12/zinc-0.3.12.tgz"
  sha256 "9c615008ae2db816622247e87d7c21e9f36a9a9b416699e08dd8cfb79ac9db6a"

  bottle :unneeded

  def install
    rm_f Dir["bin/ng/{linux,win}*"]
    libexec.install Dir["*"]
    bin.install_symlink libexec/"bin/zinc"
  end

  test do
    system "#{bin}/zinc", "-version"
  end
end
