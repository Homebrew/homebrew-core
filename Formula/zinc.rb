class Zinc < Formula
  desc "Stand-alone version of sbt's Scala incremental compiler"
  homepage "https://github.com/typesafehub/zinc"
  url "https://downloads.typesafe.com/zinc/0.3.13/zinc-0.3.13.tgz"
  sha256 "6ae329abb526afde4ee78480be1f2675310b067e3e143fbb02f429f6f816f996"

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
