class Stathat < Formula
  desc "Command-line interface to stathat.com"
  homepage "https://stathat.com"
  url "https://github.com/stathat/cmd/archive/v0.2.0.tar.gz"
  sha256 "f3771dac0394d15f670ab3073e09d1596b0d490cba99946e8631a3917144834a"

  head "https://github.com/stathat/cmd.git"

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["GOBIN"] = buildpath
    (buildpath/"src/github.com/stathat/cmd/").install "stathat"

    system "go", "build", "-a", "github.com/stathat/cmd/stathat"
    bin.install "stathat"
  end

  test do
    system "#{bin}/stathat", "version"
  end
end
