class TitanServer < Formula
  desc "Distributed graph database"
  homepage "https://thinkaurelius.github.io/titan/"
  url "http://s3.thinkaurelius.com/downloads/titan/titan-1.0.0-hadoop1.zip"
  sha256 "67538e231db5be75821b40dd026bafd0cd7451cdd7e225a2dc31e124471bb8ef"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "fc2d13173bd41bf1167fdecdff4f638e62cf91c2fbfb20aa19c91163ec465c81"
    sha256 cellar: :any_skip_relocation, big_sur:       "797828f3d981bb37ad1fcbbdf351f5b1f2aaf2e51d6795a075a2e36b93dc69e9"
    sha256 cellar: :any_skip_relocation, catalina:      "797828f3d981bb37ad1fcbbdf351f5b1f2aaf2e51d6795a075a2e36b93dc69e9"
    sha256 cellar: :any_skip_relocation, mojave:        "797828f3d981bb37ad1fcbbdf351f5b1f2aaf2e51d6795a075a2e36b93dc69e9"
  end

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
