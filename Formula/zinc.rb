class Zinc < Formula
  desc "Stand-alone version of sbt's Scala incremental compiler"
  homepage "https://github.com/typesafehub/zinc"
  url "https://downloads.typesafe.com/zinc/0.3.11/zinc-0.3.11.tgz"
  sha256 "41532cc1758af6feed7f4955b8af1465116e19045fba1fd4692c8a667e2c96a9"

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
