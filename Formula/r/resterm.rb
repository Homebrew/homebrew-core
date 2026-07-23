class Resterm < Formula
  desc "Terminal client for .http/.rest files with HTTP, GraphQL, and gRPC support"
  homepage "https://github.com/unkn0wn-root/resterm"
  url "https://github.com/unkn0wn-root/resterm/archive/refs/tags/v0.47.3.tar.gz"
  sha256 "25ede07abcb0dcac7bd257100400124e7b1cafe1d65e97ac05af2a6694f2cb8b"
  license "Apache-2.0"
  head "https://github.com/unkn0wn-root/resterm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c0596b198e03d697e637f26b3b6d508c0bc29d677aa3ce3ad485fa254659d64c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c0596b198e03d697e637f26b3b6d508c0bc29d677aa3ce3ad485fa254659d64c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c0596b198e03d697e637f26b3b6d508c0bc29d677aa3ce3ad485fa254659d64c"
    sha256 cellar: :any_skip_relocation, sonoma:        "e76b616f95a2675713e804872649ef357e5970e5b4768eef94df867bc8c13e3c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d17d48454a7c8a116370787f4231fa553328265bf60df5a603c646a9948606a4"
    sha256 cellar: :any,                 x86_64_linux:  "f6568dd1198c6310ef68f0eba8118673f8f42ee1711292feb3025fe7ad890c26"
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
