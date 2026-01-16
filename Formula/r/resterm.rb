class Resterm < Formula
  desc "Terminal client for .http/.rest files with HTTP, GraphQL, and gRPC support"
  homepage "https://github.com/unkn0wn-root/resterm"
  url "https://github.com/unkn0wn-root/resterm/archive/refs/tags/v0.18.5.tar.gz"
  sha256 "f37306ffaaa091f8c62b5dee87795624e286b6970fa02b994a4da5f3c0a63a4a"
  license "Apache-2.0"
  head "https://github.com/unkn0wn-root/resterm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7d338dc1600165d6307ce0edb7b5b9170e8c49b86ea7b015894d3e47d26dc1f7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7d338dc1600165d6307ce0edb7b5b9170e8c49b86ea7b015894d3e47d26dc1f7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7d338dc1600165d6307ce0edb7b5b9170e8c49b86ea7b015894d3e47d26dc1f7"
    sha256 cellar: :any_skip_relocation, sonoma:        "44abcc24ac9a79bca3d052f68aa418dc68846148317e5d662e210be0d7baa459"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "06010fb8a522e31104e5280287de50eab2c3aafb39a082052804db7120d2ca94"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bf6c9e358bc435e5c190323d8d114e3b92924575de27c73d7aac4ada14125860"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user} -X main.date=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/resterm"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/resterm -version")

    (testpath/"openapi.yml").write <<~YAML
      openapi: 3.0.0
      info:
        title: Test API
        version: 1.0.0
        description: A simple test API
      servers:
        - url: https://api.example.com
          description: Production server
      paths:
        /ping:
          get:
            summary: Ping endpoint
            operationId: ping
            responses:
              "200":
                description: Successful response
                content:
                  application/json:
                    schema:
                      type: object
                      properties:
                        message:
                          type: string
                          example: "pong"
      components:
        schemas:
          PingResponse:
            type: object
            properties:
              message:
                type: string
    YAML

    system bin/"resterm", "--from-openapi", testpath/"openapi.yml",
                          "--http-out",     testpath/"out.http",
                          "--openapi-base-var", "apiBase",
                          "--openapi-server-index", "0"

    assert_match "GET {{apiBase}}/ping", (testpath/"out.http").read
  end
end
