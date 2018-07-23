class Sshw < Formula
  desc "🐝  ssh client wrapper for automatic login"
  homepage "https://github.com/yinheli/sshw"
  url "https://github.com/yinheli/sshw/archive/v1.0.2.tar.gz"
  sha256 "5bb4de182683797d44cd8921a26d8732e7f29f2eb382bea47a57372c44ccaaab"

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
