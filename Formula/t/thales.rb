VERSION = "2025.02.27"

URL_AMD64 = "https://github.com/0xnu/thales/releases/download/v#{VERSION}/thales_darwin_amd64.zip"
URL_ARM64 = "https://github.com/0xnu/thales/releases/download/v#{VERSION}/thales_darwin_arm64.zip"
CHECKSUM_AMD64 = "95f456a56dfb33aa40792ce939529e5b0dd41fca65a5e797426cdb6c66466f73"
CHECKSUM_ARM64 = "810cfd283914a4c638f9ffaab7956cb069d3c367793e3c85abd02b9b69e0de3c"
LICENSE_IDENTIFIER = "BSD 3-Clause"

class Thales < Formula
  desc "A code review and documentation tool using LLMs"
  homepage "https://github.com/0xnu/thales"
  version VERSION

  on_intel do
    url URL_AMD64, using: :zip
    sha256 CHECKSUM_AMD64
  end

  on_arm do
    url URL_ARM64, using: :zip
    sha256 CHECKSUM_ARM64
  end

  license LICENSE_IDENTIFIER

  def install
    # For Intel, install the thales_darwin_amd64 binary; for ARM, install thales_darwin_arm64.
    if Hardware::CPU.intel?
      bin.install "thales_darwin_amd64" => "thales"
    elsif Hardware::CPU.arm?
      bin.install "thales_darwin_arm64" => "thales"
    end
  end

  def caveats
    <<~EOS
      Example usage commands:

      # Generate documentation:
      • ./thales --new
        → Generates a new README with default settings.
      • ./thales --update --lang es
        → Updates the README in Spanish.
      • ./thales --new --output docs/README.md
        → Generates a README in a custom output location.

      # Code review commands:
      • ./thales --cb . --llm claude
        → Reviews the codebase with the Claude LLM.
      • ./thales --sf main.go --llm openai
        → Reviews the file "main.go" with the OpenAI LLM.
      • ./thales --cb . --llm grok2
        → Reviews the codebase with Grok-2.
      • ./thales --cb . --llm mixtral
        → Reviews the codebase with Mixtral.
      • ./thales --cb . --llm claude --focus security
        → Performs a security review with Claude.
      • ./thales --cb . --llm openai --focus performance
        → Performs a performance review with OpenAI.
      • ./thales --sf main.go --llm claude --severity high
        → Reviews main.go with high-severity focus using Claude.
      • ./thales --cb . --llm openai --focus all --severity medium
        → Performs a broad review with medium severity using OpenAI.

      # Advanced options:
      • ./thales --list-languages
        → Lists supported languages.
      • ./thales --llm openai
        → Use OpenAI as the default LLM.
      • ./thales --review-output reports
        → Specifies a custom output directory for reviews.

      For more detailed documentation, please visit: https://github.com/0xnu/thales
    EOS
  end

  test do
    # A simple test to ensure the binary returns the usage message.
    assert_match "usage", shell_output("#{bin}/thales --help")
  end
end

