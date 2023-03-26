class SmithyLanguageServer < Formula
  desc "Language Server Protocol implementation for the Smithy IDL"
  homepage "https://github.com/awslabs/smithy-language-server"
  url "https://github.com/awslabs/smithy-language-server"
  version "0.2.2"
  sha256 :no_check
  license "Apache-2.0"

  depends_on "gradle" => :build
  depends_on "openjdk@11"

  def install
    system "gradle", "installDist"
  end

  test do
    input = 
       "$version: \"2.0\"\r\n" \
       "\r\n" \
       "namespace com.example\r\n" \
       "\r\n" \
       "use com.foo#emptyTraitStruct\r\n" \
       "\r\n" \
       "@emptyTraitStruct\r\n" \
       "structure OtherStructure {\r\n" \
       "    foo: String\r\n" \
       "    bar: String\r\n" \
       "    baz: Integer\r\n" \
       "}\r\n"

    output = pipe_output("#{bin}/smithy-language-server", input, 0)

    # TODO: test this once install works
    assert_match(/^Content-Length: \d+/i, output)
  end
end
