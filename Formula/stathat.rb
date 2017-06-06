class Stathat < Formula
  desc "Command-line interface to stathat.com"
  homepage "https://stathat.com"
  url "https://github.com/stathat/cmd/archive/v0.2.1.tar.gz"
  sha256 "9a63a8104da468e92fd2c50dba577f599cd0f23f93a67ac0babd36b8dfc843a0"

  head "https://github.com/stathat/cmd.git"

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/stathat/cmd/").install "stathat"

    system "go", "build", "-o", bin/"stathat", "-a", "github.com/stathat/cmd/stathat"
  end

  test do
    system "#{bin}/stathat", "version"
    system "#{bin}/stathat", "ping"
  end
end
