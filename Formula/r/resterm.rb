class Resterm < Formula
  desc "Terminal client for .http/.rest files with HTTP, GraphQL, and gRPC support"
  homepage "https://github.com/unkn0wn-root/resterm"
  url "https://github.com/unkn0wn-root/resterm/archive/refs/tags/v0.39.3.tar.gz"
  sha256 "3c933544cbf24243542ecbf79134609293afb2d07238403dee70e14f1b82ec19"
  license "Apache-2.0"
  head "https://github.com/unkn0wn-root/resterm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "aecc87fba0fc2a780f966e9b6c8c4d262663735ddb31ef2b3e66279cb728211a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "aecc87fba0fc2a780f966e9b6c8c4d262663735ddb31ef2b3e66279cb728211a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "aecc87fba0fc2a780f966e9b6c8c4d262663735ddb31ef2b3e66279cb728211a"
    sha256 cellar: :any_skip_relocation, sonoma:        "dea3332578e8cf303a8ac8a44d1c2119052f33f7f3657b6977acf95ecd26b803"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c3b0137f17589fc3dfcfbe925ee6e6a198f87906fde4af5931b358b3d729a1a4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1009b5bf1cd44c7f8a071238110dfc85254624600b2be0705bacd8fe31fc81c7"
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
