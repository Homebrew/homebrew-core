class Sshw < Formula
  desc "🐝  ssh client wrapper for automatic login"
  homepage "https://github.com/yinheli/sshw"
  url "https://github.com/yinheli/sshw/archive/v1.0.4.tar.gz"
  sha256 "53b1a4e010fc36713961aa5ce7093efc9dba07b3bf38c01f86d016b669cbc285"

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
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
