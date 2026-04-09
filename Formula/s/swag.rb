class Swag < Formula
  desc "Automatically generate RESTful API documentation with Swagger 2.0 for Go"
  homepage "https://github.com/swaggo/swag"
  url "https://github.com/swaggo/swag/archive/refs/tags/v1.16.6.tar.gz"
  sha256 "d0193f08b829e1088753ff6d66d1205e22a6e7fd07ac28df5ecb001d9eb2c43d"
  license "MIT"
  head "https://github.com/swaggo/swag.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d8cbf4841f7ebf8f91b1e4034211085e4671d8b9fd81ef7c0a4b774489bb6fbc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d8cbf4841f7ebf8f91b1e4034211085e4671d8b9fd81ef7c0a4b774489bb6fbc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d8cbf4841f7ebf8f91b1e4034211085e4671d8b9fd81ef7c0a4b774489bb6fbc"
    sha256 cellar: :any_skip_relocation, sonoma:        "3755ba02cc30db9445167444bb92257957cc5c132d93ddec55d9ca1c46938c89"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1872a5598bbfd4440343e2c2aa5fd930c3a00eb050cb2fb0afbed37d1aeb6418"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "138aa1dcd9425a4656fb0939957ca7ac30affcc0ce474062e25e7a8623cbd032"
  end

  depends_on "go" => :build

  def install
    # version patch PR, https://github.com/swaggo/swag/pull/2049
    inreplace "version.go", "1.16.4", version.to_s

    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/swag"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/swag --version")

    (testpath/"main.go").write <<~GO
      // Package main Simple API.
      // @title Simple API
      // @version 1.0.0
      // @description This is a simple API server.

      // @host localhost:8080
      // @BasePath /api/v1

      package main

      import "github.com/gin-gonic/gin"

      func main() {
        r := gin.Default()
        r.GET("/ping", func(c *gin.Context) {
          c.JSON(200, gin.H{"message": "pong"})
        })
        r.Run()
      }
    GO

    system bin/"swag", "init"
    assert_path_exists testpath/"docs/docs.go"
    assert_path_exists testpath/"docs/swagger.json"
  end
end
