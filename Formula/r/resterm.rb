class Resterm < Formula
  desc "Terminal client for .http/.rest files with HTTP, GraphQL, and gRPC support"
  homepage "https://github.com/unkn0wn-root/resterm"
  url "https://github.com/unkn0wn-root/resterm/archive/refs/tags/v0.8.5.tar.gz"
  sha256 "8ff9f235dab25d018b55a1b99b32beb4f453399d203b88bd1a75fa00dd12ffdc"
  license "Apache-2.0"
  head "https://github.com/unkn0wn-root/resterm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f14038e9346701ea0a9cf7f7899189a8156d6ae30e42da938c75cb088265a35f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f14038e9346701ea0a9cf7f7899189a8156d6ae30e42da938c75cb088265a35f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f14038e9346701ea0a9cf7f7899189a8156d6ae30e42da938c75cb088265a35f"
    sha256 cellar: :any_skip_relocation, sonoma:        "ce7c8a1c0d4d3363691afe5df8ac2012f8b828f32e76df25e08c93ac9a1c9eec"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f245edf790b311b29657d3d6b8a0f1de31f5bf672d4b73b068590f23073f9822"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "424692d7e36fd0c352fc705468232f4a992be87c259752d4187b2a06c3a55df4"
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
