class TitanServer < Formula
  desc "Distributed graph database"
  homepage "https://thinkaurelius.github.io/titan/"
  url "http://s3.thinkaurelius.com/downloads/titan/titan-1.0.0-hadoop1.zip"
  sha256 "67538e231db5be75821b40dd026bafd0cd7451cdd7e225a2dc31e124471bb8ef"

  bottle :unneeded

  def install
    libexec.install %w[bin conf data ext javadocs lib log scripts]
    bin.install_symlink libexec/"bin/titan.sh" => "titan"
    bin.install_symlink libexec/"bin/gremlin.sh" => "titan-gremlin"
    bin.install_symlink libexec/"bin/gremlin-server.sh" => "titan-gremlin-server"
  end

  test do
    system "#{bin}/titan", "stop"
  end
end
