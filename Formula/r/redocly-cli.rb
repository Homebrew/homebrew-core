class RedoclyCli < Formula
  desc "Your all-in-one OpenAPI utility"
  homepage "https://redocly.com/docs/cli"
  url "https://registry.npmjs.org/@redocly/cli/-/cli-2.12.1.tgz"
  sha256 "af5c6a432a905aa506e45f2fe8b325afe2d6922e5ab9d49959c1140b003e4c90"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8853ddbd953ef06610471e9c14e64f57e65152a4765708cc2763ebcead6796ee"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "83d190508b5d284e2bcafb5af2d78b1f522ccbea929391dfad9d3487d8ec21d5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "83d190508b5d284e2bcafb5af2d78b1f522ccbea929391dfad9d3487d8ec21d5"
    sha256 cellar: :any_skip_relocation, sonoma:        "bbe0dd75465a4764ee24c3ac53e076146dbdbdc59a561d7ba4a5228abbca5427"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4369d31729d84aecf9bc451e2735fcb8e76c39c318297062ee74e2dcfc9cef2d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4369d31729d84aecf9bc451e2735fcb8e76c39c318297062ee74e2dcfc9cef2d"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    node_modules = libexec/"lib/node_modules/@redocly/cli/node_modules"
    deuniversalize_machos node_modules/"fsevents/fsevents.node" if OS.mac?
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
