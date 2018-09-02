class Sshw < Formula
  desc "🐝  ssh client wrapper for automatic login"
  homepage "https://github.com/yinheli/sshw"
  url "https://github.com/yinheli/sshw/archive/v1.0.4.tar.gz"
  sha256 "7b48c8126f4fca50c186f864c5e9db1578d7670e2b9b0887922d5a2c56051a71"

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["SSHW_GIT_TAG"] = "v1.0.4"
    ENV["SSHW_GIT_HASH"] = "6c5d46dc"
    (buildpath/"src/github.com/yinheli/sshw").install buildpath.children

    cd "src/github.com/yinheli/sshw" do
      system "make", "sshw"
      bin.install "release/sshw"
    end
  end

  test do
    system "#{bin}/sshw", "-version"
  end
end
