class Zinc < Formula
  desc "Stand-alone version of sbt's Scala incremental compiler"
  homepage "https://github.com/typesafehub/zinc"
  url "https://downloads.typesafe.com/zinc/0.3.15/zinc-0.3.15.tgz"
  sha256 "5ec4df3fa2cbb271d65a5b478c940a9da6ef4902aa8c9d41a76dd253e3334ca7"

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
