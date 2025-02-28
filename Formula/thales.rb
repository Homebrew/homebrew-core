class Thales < Formula
  desc "A code review and documentation tool using LLMs"
  homepage "https://github.com/0xnu/thales"
  version "#{VERSION}"

  on_intel do
    url "#{URL_AMD64}"
    sha256 "#{CHECKSUM_AMD64}"
  end

  on_arm do
    url "#{URL_ARM64}"
    sha256 "#{CHECKSUM_ARM64}"
  end

  license "#{LICENSE_IDENTIFIER}"

  def install
    # Assuming the zip extracts a binary named 'thales'
    bin.install "thales"
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
    assert_match "usage", shell_output("\#{bin}/thales --help")
  end
end
