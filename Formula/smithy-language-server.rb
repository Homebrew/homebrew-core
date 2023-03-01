class SmithyLanguageServer < Formula
  desc "Language Server Protocol implementation for the Smithy IDL"
  homepage "https://github.com/awslabs/smithy-language-server"
  url "https://github.com/awslabs/smithy-language-server"
  version "0.2.2"
  sha256 :no_check
  license "Apache-2.0"

  depends_on "gradle" => :build

  def install
    system "gradle", "build"
  end

  test do
    system "gradle", "test"
  end
end
