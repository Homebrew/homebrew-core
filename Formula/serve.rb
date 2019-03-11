class Serve < Formula
  desc "Static http server anywhere you need one"
  homepage "https://github.com/syntaqx/serve"
  url "https://github.com/syntaqx/serve/archive/v0.3.0.tar.gz"
  sha256 "6bdedf3e3a83ad23cd867c480d32a9f1a91e4e7a289f81579ee4ff308c12d3eb"

  bottle do
    cellar :any_skip_relocation
    sha256 "9fe1762cda8205639c0a5dc717c940847d2e2cef2aa59ece09294de3d78a1605" => :mojave
    sha256 "ea14b31d9f2264d6cb52e760713412009a9ee2a90e9c36b460e2658b4e26ac53" => :high_sierra
    sha256 "f901ff85f818ae1bb852cd0f0a12ca41e2d9c427410f1af35701216f50dcb6fd" => :sierra
  end

  depends_on "go" => :build

  def install
    ENV["GO111MODULE"] = "on"
    ENV["GOPATH"] = buildpath

    src = buildpath/"src/github.com/syntaqx/serve"
    src.install buildpath.children
    src.cd do
      system "go", "build", "-ldflags", "-X main.version=#{version}", "-o", bin/"serve", "./cmd/serve"
      prefix.install_metafiles
    end
  end

  test do
    begin
      pid = fork do
        exec "#{bin}/serve"
      end
      sleep 1
      output = shell_output("curl -sI http://localhost:8080")
      assert_match(/200 OK/m, output)
    ensure
      Process.kill("HUP", pid)
    end
  end
end
