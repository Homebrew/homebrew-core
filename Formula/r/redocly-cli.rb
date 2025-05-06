class RedoclyCli < Formula
  desc "Your all-in-one OpenAPI utility"
  homepage "https://redocly.com/docs/cli"
  url "https://registry.npmjs.org/@redocly/cli/-/cli-1.34.3.tgz"
  sha256 "36e2e9f66eaeebbc69c0528ce7498c3c00854458265e2ce1d64271e788996927"
  license "MIT"
  head "https://github.com/redocly/redocly-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2db136099fa6e416ab4a89bac19d34f732b7365262aad71a9ff93c58856d48db"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2db136099fa6e416ab4a89bac19d34f732b7365262aad71a9ff93c58856d48db"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2db136099fa6e416ab4a89bac19d34f732b7365262aad71a9ff93c58856d48db"
    sha256 cellar: :any_skip_relocation, sonoma:        "2100eefa78559107bf5c91de4f02026b3bcfd33122db3ede587b4d2aa95cd4a7"
    sha256 cellar: :any_skip_relocation, ventura:       "2100eefa78559107bf5c91de4f02026b3bcfd33122db3ede587b4d2aa95cd4a7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2db136099fa6e416ab4a89bac19d34f732b7365262aad71a9ff93c58856d48db"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2db136099fa6e416ab4a89bac19d34f732b7365262aad71a9ff93c58856d48db"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/redocly --version")

    test_file = testpath/"openapi.yaml"
    test_file.write <<~YML
      openapi: '3.0.0'
      info:
        version: 1.0.0
        title: Swagger Petstore
        description: test
        license:
          name: MIT
          url: https://opensource.org/licenses/MIT
      servers: #ServerList
        - url: http://petstore.swagger.io:{Port}/v1
          variables:
            Port:
              enum:
                - '8443'
                - '443'
              default: '8443'
      security: [] # SecurityRequirementList
      tags: # TagList
        - name: pets
          description: Test description
        - name: store
          description: Access to Petstore orders
      paths:
        /pets:
          get:
            summary: List all pets
            operationId: list_pets
            tags:
              - pets
            parameters:
              - name: Accept-Language
                in: header
                description: 'The language you prefer for messages. Supported values are en-AU, en-CA, en-GB, en-US'
                example: en-US
                required: false
                schema:
                  type: string
                  default: en-AU
            responses:
              '200':
                description: An paged array of pets
                headers:
                  x-next:
                    description: A link to the next page of responses
                    schema:
                      type: string
                content:
                  application/json:
                    encoding:
                      historyMetadata:
                        contentType: application/json; charset=utf-8
                links:
                  address:
                    operationId: getUserAddress
                    parameters:
                      userId: $request.path.id
    YML

    assert_match "Woohoo! Your API description is valid. 🎉",
      shell_output("#{bin}/redocly lint --extends=minimal #{test_file} 2>&1")
  end
end
