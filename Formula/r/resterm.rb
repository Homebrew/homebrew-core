class Resterm < Formula
  desc "Terminal client for .http/.rest files with HTTP, GraphQL, and gRPC support"
  homepage "https://github.com/unkn0wn-root/resterm"
  url "https://github.com/unkn0wn-root/resterm/archive/refs/tags/v0.7.8.tar.gz"
  sha256 "d8d88dd0ae56748dfb73eb8cdd0dc8064df8a45e609ab39fee1b185b7969bc0f"
  license "Apache-2.0"
  head "https://github.com/unkn0wn-root/resterm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9c9e137ab2016a47b26bd7e2d285e6cc3556ff62ec7c1507a8108525f816ea37"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9c9e137ab2016a47b26bd7e2d285e6cc3556ff62ec7c1507a8108525f816ea37"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9c9e137ab2016a47b26bd7e2d285e6cc3556ff62ec7c1507a8108525f816ea37"
    sha256 cellar: :any_skip_relocation, sonoma:        "0afd156c3fae891e7858ad38250a5ffcaa85546d41653cf5cb14f04aa108d3e4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5539c9693cc96a94fd2ec7f53f0372545ef4f9aea446f548b70418c0d221d862"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ee0e0e2f0313ce4a7bd16c35fe154a216bda77ed67ea7efa50fb3d975d9347b1"
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
