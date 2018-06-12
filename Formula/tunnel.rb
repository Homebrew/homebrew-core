class Tunnel < Formula
  desc "Expose local servers to internet securely"
  homepage "https://labstack.com/docs/tunnel"
  url "https://github.com/labstack/tunnel/archive/0.2.10.tar.gz"
  sha256 "508eeae920e4f70b68ba6921f5e46b4d8a1061710adb52b5f95570547d61699e"

  bottle do
    cellar :any_skip_relocation
    sha256 "448b3fbb06dfa65c35897de53d1284cda9c1b81c3f4326d06effe3429b3e4a74" => :high_sierra
    sha256 "c6ea4626e2bf2b80816df0ec4cc32709613fc9074c2112722043c8ef196ac8bb" => :sierra
    sha256 "b8b092e5743c72ae9387c5c67862539133475c48424ee09dd0abaedb626dc488" => :el_capitan
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/labstack/tunnel").install buildpath.children
    cd "src/github.com/labstack/tunnel" do
      system "go", "build", "-o", bin/"tunnel", "./cmd/tunnel"
      prefix.install_metafiles
    end
  end

  test do
    begin
      pid = fork do
        $stdout.reopen("#{testpath}/out", "w")
        exec bin/"tunnel", "8080"
      end
      sleep 5
      assert_match "labstack.me", (testpath/"out").read
    ensure
      Process.kill("HUP", pid)
    end
  end
end
