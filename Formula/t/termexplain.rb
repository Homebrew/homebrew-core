class Termexplain < Formula
    desc "AI-powered CLI error explainer using Gemini"
    homepage "https://github.com/smundhra-git/termExplain"
    url "https://github.com/smundhra-git/termExplain/archive/refs/tags/v1.0.0.tar.gz"
    sha256 "da7de1993cf7fa3b2f0cd26532fd93779fd5f0b344a75fa3d51e296ccfa9474f"
    license "MIT"
    head "https://github.com/smundhra-git/termExplain.git", branch: "main"
  
    depends_on "python@3.11"
  
    def install
      # Just install the wrapper shell script as the CLI command
      bin.install "explain.sh" => "explain"
  
      # Install your actual scripts to libexec so they're accessible
      libexec.install "main.py", "gemini_client.py", "prompt_builder.py"
  
      # Rewrite the script to point to the correct path
      inreplace bin/"explain", "$SCRIPT_DIR/main.py", "#{libexec}/main.py"
    end
  
    test do
      assert_match "❌ Error: Python 3 is not installed", shell_output("#{bin}/explain", 1)
    end
  
    def caveats
      <<~EOS
        termExplain requires a Gemini API key to function.
  
        Set your API key:
          export GEMINI_API_KEY="your-api-key-here"
  
        Or add to your shell profile (~/.zshrc or ~/.bashrc):
          echo 'export GEMINI_API_KEY="your-api-key-here"' >> ~/.zshrc
  
        Get your API key from: https://aistudio.google.com/
  
        Usage:
          explain "your error message here"
      EOS
    end
  end
  